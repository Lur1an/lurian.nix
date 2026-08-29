{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: let
    testPkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    mkHome = extraModules:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = testPkgs;
        modules =
          [
            inputs.self.homeModules.default
            {
              home = {
                username = "terminal-test";
                homeDirectory =
                  if testPkgs.stdenv.isDarwin
                  then "/Users/terminal-test"
                  else "/home/terminal-test";
                stateVersion = "25.11";
              };
              lurian.terminal.codeFont = "monospace";
            }
          ]
          ++ extraModules;
      };
    inert = mkHome [];
    walOnly = mkHome [{lurian.terminal.wal.enable = true;}];
    matugenOnly = mkHome [{lurian.terminal.matugen.enable = true;}];
    opencodeWal = mkHome [
      {
        lurian.terminal = {
          wal.enable = true;
          opencode.enable = true;
        };
      }
    ];
    full = mkHome [
      {
        lurian.terminal = {
          neovim.enable = true;
          wal.enable = true;
          matugen.enable = true;
          ghostty.enable = true;
          tmux.enable = true;
          opencode.enable = true;
          treehouse.enable = true;
          zsh.enable = true;
          omp.enable = true;
          lazygit.enable = true;
        };
      }
    ];
    pluginsDisabled = mkHome [
      {
        lurian.terminal.neovim.enable = true;
        programs.nixvim.plugins = {
          nvchad.enable = false;
          telescope.enable = false;
          trouble.enable = false;
          cmp.enable = false;
          dap.enable = false;
          dap-ui.enable = false;
          dap-python.enable = false;
          opencode.enable = false;
          snacks.enable = false;
          treesitter.enable = false;
        };
      }
    ];
    assertCheck = name: condition:
      assert condition;
        pkgs.runCommand name {} "touch $out";
    nvimCheck = name: home:
      pkgs.runCommand name {
        nativeBuildInputs = [home.config.programs.nixvim.build.package];
      } ''
        export HOME=$TMPDIR/home
        export XDG_CONFIG_HOME=$HOME/.config
        export XDG_DATA_HOME=$HOME/.local/share
        mkdir -p "$XDG_CONFIG_HOME/nvim/lua" "$XDG_DATA_HOME/nvim"
        cp ${./neovim/files/lua/nixvim/chadrc.lua} "$XDG_CONFIG_HOME/nvim/lua/chadrc.lua"
        nvim --headless '+qa'
        touch "$out"
      '';
  in {
    checks =
      {
        inert = assertCheck "terminal-inert" (
          !inert.config.programs.nixvim.enable
          && !inert.config.programs.ghostty.enable
          && !inert.config.programs.tmux.enable
        );
        engines = assertCheck "terminal-empty-engines" (
          builtins.attrNames walOnly.config.lurian.terminal.wal.templates
          == []
          && builtins.attrNames matugenOnly.config.lurian.terminal.matugen.templates == []
          && matugenOnly.config.xdg.configFile."matugen/config.toml".text == "[config]\n"
        );
        opencode-wal = assertCheck "terminal-opencode-wal" (
          builtins.attrNames opencodeWal.config.lurian.terminal.wal.templates
          == ["opencode-wal.json"]
          && opencodeWal.config.xdg.configFile ? "opencode/themes/wal.json"
        );
      }
      // lib.optionalAttrs (system == "x86_64-linux") {
        full = full.activationPackage;
        plugins-disabled = pluginsDisabled.activationPackage;
        nvim-full = nvimCheck "terminal-nvim-full" full;
        nvim-plugins-disabled = nvimCheck "terminal-nvim-plugins-disabled" pluginsDisabled;
      };
  };
}
