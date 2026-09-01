{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.lurian.terminal.zshAi;

  yamlFormat = pkgs.formats.yaml {};

  aichatConfig = {
    model = "ollama:${cfg.model}";
    clients = [
      {
        type = "openai-compatible";
        name = "ollama";
        api_base = cfg.apiBase;
        models = map (name: {
          inherit name;
          max_input_tokens = cfg.maxInputTokens;
        }) ([cfg.model] ++ cfg.extraModels);
      }
    ];
  };
in {
  options.lurian.terminal.zshAi = {
    enable = lib.mkEnableOption "AI command generation in zsh via aichat + local ollama";

    model = lib.mkOption {
      type = lib.types.str;
      default = "qwen3:4b-instruct-2507-q4_K_M";
      description = "Default ollama model used for shell command generation";
    };

    extraModels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional ollama models to register in aichat (switch with `aichat -m ollama:<name>`)";
    };

    apiBase = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:11434/v1";
      description = "OpenAI-compatible API endpoint of the local ollama instance";
    };

    maxInputTokens = lib.mkOption {
      type = lib.types.int;
      default = 32768;
      description = "max_input_tokens advertised to aichat for each model";
    };

    keybind = lib.mkOption {
      type = lib.types.str;
      default = "\\ee"; # Alt+E
      description = "zsh bindkey sequence that turns the current buffer into a shell command";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.aichat];

    xdg.configFile."aichat/config.yaml".source =
      yamlFormat.generate "aichat-config.yaml" aichatConfig;

    # Widget: type natural language (or a partial command), hit the keybind,
    # buffer gets replaced with the generated command. Enter still required to run.
    programs.zsh.initContent = ''
      _aichat_zsh() {
        if [[ -n "$BUFFER" ]]; then
          local _old=$BUFFER
          BUFFER+=" ⌛"
          zle -I && zle redisplay
          BUFFER=$(${pkgs.aichat}/bin/aichat -e "$_old")
          zle end-of-line
        fi
      }
      zle -N _aichat_zsh
      bindkey '${cfg.keybind}' _aichat_zsh
      # zsh-vi-mode clobbers custom binds during its lazy init; re-apply after
      zvm_after_init_commands+=("bindkey '${cfg.keybind}' _aichat_zsh")
    '';
  };
}
