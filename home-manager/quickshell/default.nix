{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.quickshell;
in {
  options.quickshell = {
    enable = lib.mkEnableOption "Quickshell desktop shell with AI widget";

    aiWidget = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable AI chat widget in the sidebar";
      };

      defaultModel = lib.mkOption {
        type = lib.types.str;
        default = "ollama-llama3.2";
        description = "Default AI model to use";
      };

      ollamaEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:11434/v1/chat/completions";
        description = "Ollama API endpoint";
      };

      openaiEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "https://api.openai.com/v1/chat/completions";
        description = "OpenAI API endpoint";
      };
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto-start Quickshell with Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      quickshell
      libsecret # For secret-tool (API key storage)
      jq # For JSON parsing in scripts
      curl # For API requests
    ];

    # Symlink the quickshell config directory
    xdg.configFile."quickshell".source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/lurian.nix/home-manager/quickshell/config";

    # Add to Hyprland exec-once if autoStart is enabled
    wayland.windowManager.hyprland.settings.exec-once = lib.optionals cfg.autoStart [
      "quickshell"
    ];

    # Add keybind to toggle sidebar
    wayland.windowManager.hyprland.settings.bind = [
      "SUPER, A, exec, qs ipc call sidebar toggle"
    ];
  };
}
