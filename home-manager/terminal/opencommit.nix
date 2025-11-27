{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.terminal;
in {
  config = lib.mkIf cfg.opencommit.enable {
    home.packages = with pkgs; [
      opencommit
    ];
    home.sessionVariables = {
      OCO_AI_PROVIDER = "openai";
      OCO_API_URL = "https://openrouter.ai/api/v1";
      OCO_MODEL = "google/gemini-3-pro-preview";
      OCO_DESCRIPTION = "false";
      OCO_EMOJI = "true";
      OCO_PROMPT_MODULE = "conventional-commit";
    };
  };
}
