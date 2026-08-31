{
  inputs,
  module,
  system,
  pkgs,
}: let
  lib = inputs.nixpkgs.lib;
  testPkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  mkHome = extraModules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = testPkgs;
      modules =
        [
          module
          {
            home = {
              username = "terminal-test";
              homeDirectory =
                if testPkgs.stdenv.hostPlatform.isDarwin
                then "/Users/terminal-test"
                else "/home/terminal-test";
              stateVersion = "25.11";
            };
            lurian.terminal.codeFont = "monospace";
            lurian.terminal.agents_md_path = builtins.toFile "RULES.md" "# Test rules\n";
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
  skillsSource = pkgs.runCommand "terminal-test-skills" {} ''
    mkdir -p "$out/example"
    touch "$out/example/SKILL.md"
  '';
  skillsHome = mkHome [
    {
      lurian.terminal = {
        opencode.enable = true;
        skills = skillsSource;
      };
    }
  ];
  full = mkHome [
    {
      lurian.terminal = {
        neovim.enable = true;
        wal.enable = true;
        matugen.enable = true;
        fonts.enable = true;
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
  togglesDisabled = mkHome [
    {
      lurian.terminal.neovim = {
        enable = true;
        neocord.enable = false;
        markdownPreview.enable = false;
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
      cp ${./modules/neovim/files/lua/nixvim/chadrc.lua} "$XDG_CONFIG_HOME/nvim/lua/chadrc.lua"
      nvim --headless '+qa'
      touch "$out"
    '';
in
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
    skills = assertCheck "terminal-skills" (
      skillsHome.config.xdg.configFile."opencode/skills".source
      == skillsSource
      && skillsHome.config.xdg.configFile."opencode/skills".recursive
    );
  }
  // lib.optionalAttrs (system == "x86_64-linux") {
    full = full.activationPackage;
    toggles-disabled = togglesDisabled.activationPackage;
    nvim-full = nvimCheck "terminal-nvim-full" full;
    nvim-toggles-disabled = nvimCheck "terminal-nvim-toggles-disabled" togglesDisabled;
  }
