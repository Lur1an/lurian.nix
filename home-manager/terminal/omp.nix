{
  config,
  inputs,
  pkgs,
  ...
}: let
  package = inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default;
  yamlFormat = pkgs.formats.yaml {};
in {
  imports = [inputs.omp.homeManagerModules.default];

  programs.omp = {
    enable = true;
    inherit package;
    settings = {
      startup.quiet = true;
    };
  };

  home.file.".omp/agent/keybindings.yml".source = yamlFormat.generate "omp-keybindings.yml" {
    "tui.editor.cursorLeft" = ["Left" "Ctrl+B" "Alt+H"];
    "tui.editor.cursorDown" = ["Down" "Alt+J"];
    "tui.editor.cursorUp" = ["Up" "Alt+K"];
    "tui.editor.cursorRight" = ["Right" "Ctrl+F" "Alt+L"];
    "tui.editor.cursorWordLeft" = ["Alt+Left" "Ctrl+Left" "Alt+B"];
    "tui.editor.cursorWordRight" = ["Alt+Right" "Ctrl+Right" "Alt+F" "Alt+W"];
    "tui.editor.deleteCharForward" = ["Delete" "Ctrl+D" "Alt+X"];
    "tui.editor.undo" = ["Ctrl+-" "Ctrl+_" "Alt+U"];
    "tui.select.up" = ["Up" "Ctrl+P"];
    "tui.select.down" = ["Down" "Ctrl+N"];
    "app.model.cycleForward" = [];
    "app.display.reset" = "Alt+Shift+L";
  };

  home.file.".omp/agent/mcp.json".source = config.xdg.configFile."mcp/mcp.json".source;
}
