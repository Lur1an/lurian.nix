{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.lurian.terminal.opencommit;
in {
  options.lurian.terminal.opencommit.enable = lib.mkEnableOption "OpenCommit";
  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.opencommit];
    home.sessionVariables = {
      OCO_AI_PROVIDER = "openai";
      OCO_API_URL = "https://openrouter.ai/api/v1";
      OCO_MODEL = "google/gemini-3-flash-preview";
      OCO_DESCRIPTION = "false";
      OCO_EMOJI = "true";
      OCO_PROMPT_MODULE = "conventional-commit";
    };
  };
}
