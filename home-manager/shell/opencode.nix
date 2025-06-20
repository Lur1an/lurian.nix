{pkgs, ...}: {
  home.packages = with pkgs; [
  ];
  home.file. ".config/opencode/config.json".text =
    builtins.toJSON
    {
      provider = {
        openrouter = {
          npm = "@openrouter/ai-sdk-provider";
          name = "OpenRouter";
          options = {};
          models = {
            "google/gemini-2.5-pro" = {
              name = "gemini 2.5 pro";
            };
            "anthropic/claude-sonnet-4" =  {
              name = "Claude sonnet 4";
            };
          };
        };
      };
    };
}
