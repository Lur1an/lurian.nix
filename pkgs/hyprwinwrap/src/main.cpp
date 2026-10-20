#define WLR_USE_UNSTABLE

#include <algorithm>
#include <array>
#include <any>
#include <cmath>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>
#include <hyprland/src/includes.hpp>

#define private public
#define protected public
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/desktop/view/window/Window.hpp>
#include <hyprland/src/config/ConfigManager.hpp>
#include <hyprland/src/desktop/rule/Engine.hpp>
#include <hyprland/src/desktop/rule/windowRule/WindowRule.hpp>
#include <hyprland/src/render/Renderer.hpp>
#include <hyprland/src/managers/input/InputManager.hpp>
#include <hyprland/src/event/EventBus.hpp>
#undef private
#undef protected

#include <hyprland/src/config/values/ConfigValues.hpp>
#include <hyprland/src/desktop/view/window/WindowMetadata.hpp>
#include <hyprland/src/desktop/view/window/WindowPresentation.hpp>
#include <hyprland/src/helpers/time/Time.hpp>
#include <hyprland/src/layout/LayoutManager.hpp>
#include <hyprland/src/layout/target/Target.hpp>
#include <hyprland/src/render/WindowRenderPresentation.hpp>
#include "globals.hpp"

extern "C" {
#include <lua.h>
#include <lauxlib.h>
}

struct SWindowSpec {
    std::string className;
    std::string title;
    double posX = 0, posY = 0, sizeX = 100, sizeY = 100;
};

struct SBackgroundWindow {
    PHLWINDOWREF window;
    SWindowSpec spec;
    bool wasPinned;
};

static std::vector<SWindowSpec> luaSpecs;
static std::vector<SWindowSpec> specs;
static std::vector<SBackgroundWindow> bgWindows;
static std::vector<SP<Desktop::Rule::IRule>> bgRules;
static std::array<SP<Config::Values::CStringValue>, 6> configValues;
static CFunctionHook* subsurfaceHook = nullptr;
static CFunctionHook* commitHook = nullptr;
using origCommitSubsurface = void (*)(Desktop::View::CSubsurface*);
using origCommit = void (*)(Desktop::View::CWindow*, bool);

APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

static bool isBackground(const PHLWINDOW& window) {
    return window && std::ranges::any_of(bgWindows, [&](const auto& bg) { return bg.window.lock() == window; });
}

static const SWindowSpec* matchingSpec(const PHLWINDOW& window) {
    for (const auto& spec : specs) {
        if ((!spec.className.empty() && window->metadata().initialAppID() == spec.className) ||
            (!spec.title.empty() && window->metadata().title() == spec.title))
            return &spec;
    }
    return nullptr;
}

static void clearWindowRules() {
    for (auto& rule : bgRules)
        Desktop::Rule::ruleEngine()->unregisterRule(rule);
    bgRules.clear();
}

static void addWindowRule(const std::string& name, Desktop::Rule::eRuleProperty property, const std::string& match) {
    if (match.empty())
        return;

    // Configured class/title strings are literal, including regex metacharacters.
    std::string escaped;
    for (char ch : match) {
        if (std::string_view{R"(\.^$|()[]{}*+?)"}.find(ch) != std::string_view::npos)
            escaped += '\\';
        escaped += ch;
    }
    auto rule = makeShared<Desktop::Rule::CWindowRule>(name);
    rule->registerMatch(property, "^(" + escaped + ")$");
    for (const auto& [effect, value] : {std::pair{Desktop::Rule::WINDOW_RULE_EFFECT_FLOAT, "1"},
                                      std::pair{Desktop::Rule::WINDOW_RULE_EFFECT_SIZE, "100% 100%"}}) {
        if (const auto result = rule->addEffect(effect, value); !result) {
            HyprlandAPI::addNotification(PHANDLE, "[hyprwinwrap] Invalid window rule: " + result.error(), CHyprColor{1.0, 0.2, 0.2, 1.0}, 5000);
            return;
        }
    }
    bgRules.emplace_back(rule);
    Desktop::Rule::ruleEngine()->registerRule(SP<Desktop::Rule::IRule>{rule});
}

static void applyGeometry(const PHLWINDOW& window, const SWindowSpec& spec) {
    const auto monitor = window->m_monitor.lock();
    const auto target = window->layoutTarget();
    if (!monitor || !target)
        return;

    if (!target->floating())
        g_layoutManager->changeFloatingMode(target);

    const double px = std::clamp(spec.posX, 0.0, 99.0);
    const double py = std::clamp(spec.posY, 0.0, 99.0);
    const double sx = std::min(std::clamp(spec.sizeX, 1.0, 100.0), 100.0 - px);
    const double sy = std::min(std::clamp(spec.sizeY, 1.0, 100.0), 100.0 - py);
    const Vector2D size = {monitor->m_size.x * sx / 100.0, monitor->m_size.y * sy / 100.0};
    const Vector2D pos = {monitor->m_position.x + monitor->m_size.x * px / 100.0, monitor->m_position.y + monitor->m_size.y * py / 100.0};

    target->setPositionGlobal(CBox{pos.x, pos.y, size.x, size.y});
    target->warpPositionSize();
    window->m_realSize->setValueAndWarp(size);
    window->m_realPosition->setValueAndWarp(pos);
    window->sendWindowSize(true);
}

static void onNewWindow(PHLWINDOW window) {
    const auto spec = matchingSpec(window);
    if (!spec || isBackground(window) || !window->m_monitor.lock())
        return;

    const bool wasPinned = bool(window->m_state & Desktop::View::WINDOW_STATE_PINNED);
    applyGeometry(window, *spec);
    window->m_state |= Desktop::View::WINDOW_STATE_PINNED;
    bgWindows.push_back({window, *spec, wasPinned});
    window->m_hidden = true;
    g_pInputManager->refocus();
}

static void restoreWindow(const SBackgroundWindow& bg) {
    if (const auto window = bg.window.lock()) {
        window->m_hidden = false;
        window->setSuspended(false);
        if (!bg.wasPinned)
            window->m_state &= ~Desktop::View::WINDOW_STATE_PINNED;
        g_pHyprRenderer->damageWindow(window);
    }
}

static void onRenderStage(const Event::SRenderStageEvent& event) {
    if (event.stage != RENDER_POST_WALLPAPER || !event.context || !event.monitor)
        return;

    for (auto& bg : bgWindows) {
        const auto window = bg.window.lock();
        if (!window || window->m_monitor.lock() != event.monitor)
            continue;

        // Hidden wallpaper windows must still receive client frames.
        window->setSuspended(false);
        window->m_hidden = false;
        const auto presentation = window->presentation().renderPresentation();
        g_pHyprRenderer->renderWindow(event.context->get(), window, event.monitor, presentation, Time::steadyNow(), false, Render::RENDER_PASS_ALL, false, true);
        window->m_hidden = true;
    }
}

static void onCommitSubsurface(Desktop::View::CSubsurface* subsurface) {
    const auto window = Desktop::View::CWindow::fromView(subsurface->wlSurface()->view());
    const bool background = isBackground(window);
    if (background)
        window->m_hidden = false;

    reinterpret_cast<origCommitSubsurface>(subsurfaceHook->m_original)(subsurface);

    if (background) {
        g_pHyprRenderer->damageWindow(window);
        window->m_hidden = true;
    }
}

static void onCommit(Desktop::View::CWindow* owner, bool initialCommit) {
    const auto window = owner->m_self.lock();
    const bool background = isBackground(window);
    if (background)
        window->m_hidden = false;

    reinterpret_cast<origCommit>(commitHook->m_original)(owner, initialCommit);

    if (background) {
        g_pHyprRenderer->damageWindow(window);
        window->m_hidden = true;
    }
}

static double configNumber(size_t index, double fallback) {
    try {
        const double value = std::stod(configValues[index]->value());
        return std::isfinite(value) ? value : fallback;
    } catch (...) {
        return fallback;
    }
}

static void onConfigReloaded() {
    clearWindowRules();
    specs = luaSpecs;
    const SWindowSpec legacy{configValues[0]->value(), configValues[1]->value(), configNumber(2, 0), configNumber(3, 0), configNumber(4, 100), configNumber(5, 100)};
    if (!legacy.className.empty() || !legacy.title.empty())
        specs.push_back(legacy);

    for (size_t i = 0; i < specs.size(); ++i) {
        addWindowRule("hyprwinwrap-class-" + std::to_string(i), Desktop::Rule::RULE_PROP_CLASS, specs[i].className);
        addWindowRule("hyprwinwrap-title-" + std::to_string(i), Desktop::Rule::RULE_PROP_TITLE, specs[i].title);
    }
    Desktop::Rule::ruleEngine()->updateAllRules();

    std::erase_if(bgWindows, [](auto& bg) {
        const auto window = bg.window.lock();
        if (!window)
            return true;
        const auto spec = matchingSpec(window);
        if (!spec) {
            restoreWindow(bg);
            return true;
        }
        bg.spec = *spec;
        applyGeometry(window, bg.spec);
        g_pHyprRenderer->damageWindow(window);
        return false;
    });
}

static int luaWindow(lua_State* state) {
    luaL_checktype(state, 1, LUA_TTABLE);
    SWindowSpec spec;
    const auto getString = [&](const char* key, std::string& value) {
        lua_getfield(state, 1, key);
        if (lua_isstring(state, -1))
            value = lua_tostring(state, -1);
        lua_pop(state, 1);
    };
    const auto getNumber = [&](const char* key, double& value) {
        lua_getfield(state, 1, key);
        if (lua_isnumber(state, -1)) {
            const auto number = lua_tonumber(state, -1);
            if (std::isfinite(number))
                value = number;
        }
        lua_pop(state, 1);
    };
    getString("class", spec.className);
    getString("title", spec.title);
    getNumber("pos_x", spec.posX);
    getNumber("pos_y", spec.posY);
    getNumber("size_x", spec.sizeX);
    getNumber("size_y", spec.sizeY);
    if (spec.className.empty() && spec.title.empty())
        return luaL_error(state, "hyprwinwrap.window requires a class or title");
    luaSpecs.push_back(spec);
    return 0;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;
    if (std::string_view{__hyprland_api_get_hash()} != __hyprland_api_get_client_hash())
        throw std::runtime_error("hyprwinwrap: compositor and plugin versions do not match");

    static auto openListener = Event::bus()->m_events.window.open.listen([](PHLWINDOW window) { onNewWindow(window); });
    static auto closeListener = Event::bus()->m_events.window.close.listen([](PHLWINDOW window) {
        std::erase_if(bgWindows, [&](const auto& bg) { return bg.window.expired() || bg.window.lock() == window; });
    });
    static auto renderListener = Event::bus()->m_events.render.stage.listen([](const Event::SRenderStageEvent& event) { onRenderStage(event); });
    static auto reloadListener = Event::bus()->m_events.config.reloaded.listen([] { onConfigReloaded(); });
    static auto preReloadListener = Event::bus()->m_events.config.preReload.listen([] { luaSpecs.clear(); });
    static auto workspaceListener = Event::bus()->m_events.workspace.active.listen([](PHLWORKSPACE) {
        for (const auto& bg : bgWindows)
            if (const auto window = bg.window.lock())
                applyGeometry(window, bg.spec);
    });

    auto functions = HyprlandAPI::findFunctionsByName(PHANDLE, "_ZN7Desktop4View11CSubsurface8onCommitEv");
    if (functions.empty())
        throw std::runtime_error("hyprwinwrap: CSubsurface::onCommit not found");
    subsurfaceHook = HyprlandAPI::createFunctionHook(PHANDLE, functions[0].address, reinterpret_cast<void*>(&onCommitSubsurface));

    functions = HyprlandAPI::findFunctionsByName(PHANDLE, "_ZN7Desktop4View7CWindow12commitWindowEb");
    if (functions.empty())
        throw std::runtime_error("hyprwinwrap: CWindow::commitWindow(bool) not found");
    commitHook = HyprlandAPI::createFunctionHook(PHANDLE, functions[0].address, reinterpret_cast<void*>(&onCommit));
    if (!subsurfaceHook || !commitHook || !subsurfaceHook->hook() || !commitHook->hook())
        throw std::runtime_error("hyprwinwrap: hooks failed");

    const std::array<const char*, 6> names = {"plugin:hyprwinwrap:class", "plugin:hyprwinwrap:title", "plugin:hyprwinwrap:pos_x",
                                             "plugin:hyprwinwrap:pos_y", "plugin:hyprwinwrap:size_x", "plugin:hyprwinwrap:size_y"};
    const std::array<const char*, 6> defaults = {"kitty-bg", "", "0", "0", "100", "100"};
    for (size_t i = 0; i < names.size(); ++i) {
        configValues[i] = makeShared<Config::Values::CStringValue>(names[i], "Wallpaper window setting", defaults[i]);
        HyprlandAPI::addConfigValueV2(PHANDLE, configValues[i]);
    }
    HyprlandAPI::addLuaFunction(PHANDLE, "hyprwinwrap", "window", &luaWindow);
    onConfigReloaded();
    return {"hyprwinwrap", "A clone of xwinwrap for Hyprland", "Vaxry", "1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    clearWindowRules();
    for (const auto& bg : bgWindows)
        restoreWindow(bg);
    bgWindows.clear();
}
