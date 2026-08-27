{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./helpers.nix) luaExpr;
  chadrcPath = "${config.xdg.dataHome}/nvim/chadrc.lua";
  nvchadCore = pkgs.vimPlugins.nvchad.overrideAttrs (_: {
    dependencies = with pkgs.vimPlugins; [
      luasnip
      nvchad-ui
    ];
  });
in {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      nvchadCore
      nvchad-ui
      base46
      nvzone-volt
      nvzone-menu
      nvzone-minty
    ];

    extraFiles = {
      "lua/nixvim/chadrc_defaults.lua".source = ../../dotfiles/nvim/lua/nixvim/chadrc_defaults.lua;
      "lua/nixvim/theme.lua".source = ../../dotfiles/nvim/lua/nixvim/theme.lua;
    };

    extraConfigLuaPre = lib.mkBefore (luaExpr {
      module = "theme";
      function = "pre";
      call = true;
    });
    extraConfigLuaPost = lib.mkAfter (luaExpr {
      module = "theme";
      function = "post";
      call = true;
    });
  };

  xdg.configFile."nvim/lua/chadrc.lua".source =
    config.lib.file.mkOutOfStoreSymlink chadrcPath;

  home.activation.seedNvimChadrc = lib.hm.dag.entryAfter ["linkGeneration"] ''
    chadrc=${lib.escapeShellArg chadrcPath}

    if [[ ! -e "$chadrc" ]]; then
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -Dm600 \
        ${../../dotfiles/nvim/lua/nixvim/chadrc.lua} "$chadrc"
    fi
  '';
}
