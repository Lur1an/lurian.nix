{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.hyprdesktop;
  settingValueType = with lib.types;
    nullOr (oneOf [
      bool
      int
      float
      str
      path
      (attrsOf settingValueType)
      (listOf settingValueType)
    ]);
  luaFiles = [
    "hyprland.lua"
    "config.lua"
    "binds.lua"
    "rules.lua"
    "colors.lua"
  ];
  luaFileLinks = lib.genAttrs' luaFiles (file:
    lib.nameValuePair "hypr/${file}" {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/lurian.nix/home-manager/hyprland/lua/${file}";
    });
  machineConfig = {
    plugin = "${pkgs.hyprwinwrap}/lib/libhyprwinwrap.so";
    monitors = cfg.monitor;
    extraBinds = cfg.extraBinds;
    floatingWindows = cfg.floatingWindows;
    windowRules = cfg.customWindowRules;
    workspaceRules = cfg.workspaceRules;
    configOverrides = cfg.configOverrides;
    startupCommands = cfg.extraStartupCommands;
    sessionStartupCommand = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target";
  };
in {
  options.hyprdesktop = {
    monitor = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          output = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          mode = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          position = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          scale = lib.mkOption {
            type = lib.types.nullOr (lib.types.oneOf [
              lib.types.int
              lib.types.float
              lib.types.str
            ]);
            default = null;
          };
          disabled = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      });
      description = "Monitor configuration";
      default = [
        {
          mode = "preferred";
          position = "auto-right";
          scale = 1.25;
        }
      ];
    };
    extraBinds = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          keys = lib.mkOption {
            type = lib.types.str;
            description = "Key combination";
          };
          command = lib.mkOption {
            type = lib.types.str;
            description = "Command to execute";
          };
          locked = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          repeating = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      });
      description = "Extra command bindings";
      default = [];
    };
    floatingWindows = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Class regular expressions for floating windows";
      default = [];
    };
    customWindowRules = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          class = lib.mkOption {
            type = lib.types.str;
            description = "Window class regular expression";
          };
          workspace = lib.mkOption {
            type = lib.types.str;
            description = "Destination workspace";
          };
          silent = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      });
      description = "Workspace rules for application windows";
      default = [];
    };
    workspaceRules = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          workspace = lib.mkOption {
            type = lib.types.str;
            description = "Workspace selector";
          };
          monitor = lib.mkOption {
            type = lib.types.str;
            description = "Monitor selector";
          };
        };
      });
      description = "Workspace-to-monitor assignments";
      default = [];
    };
    configOverrides = lib.mkOption {
      type = settingValueType;
      description = "Machine-specific values passed to hl.config";
      default = {};
    };
    extraStartupCommands = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Machine-specific commands run when Hyprland starts";
      default = [];
    };
  };

  config = {
    home.packages = with pkgs; [
      slurp
      grim
      mpv
    ];

    xdg.configFile =
      luaFileLinks
      // {
        "hypr/machine.lua".text = ''
          return ${lib.generators.toLua {} machineConfig}
        '';
      };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      plugins = [];
      settings = {};
      systemd.enable = false;
      xwayland.enable = true;
    };

    systemd.user.targets.hyprland-session.Unit = {
      Description = "Hyprland compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
      PropagatesStopTo = ["graphical-session.target"];
    };
  };
}
