cmake_minimum_required(VERSION 3.27)

project(hyprwinwrap
    DESCRIPTION "hyprwinwrap plugin for Hyprland"
    VERSION 0.1
)

set(CMAKE_CXX_STANDARD 23)

add_library(hyprwinwrap SHARED main.cpp)

find_package(PkgConfig REQUIRED)
pkg_check_modules(deps REQUIRED IMPORTED_TARGET
    hyprland
    libdrm
    libinput
    libudev
    pangocairo
    pixman-1
    wayland-server
    xkbcommon
)
pkg_search_module(lua REQUIRED IMPORTED_TARGET lua55 lua5.5 lua-5.5 lua5.4 lua)
target_link_libraries(hyprwinwrap PRIVATE rt PkgConfig::deps PkgConfig::lua)

install(TARGETS hyprwinwrap LIBRARY DESTINATION lib)
install(FILES LICENSE DESTINATION share/licenses/hyprwinwrap)
