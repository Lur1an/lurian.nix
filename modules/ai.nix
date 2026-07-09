# Local AI stack: ollama (GPU) + Open WebUI, running as native NixOS services
{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda; # Nvidia GPU acceleration
    models = "/mnt/Data/ollama/models"; # model weights on the HDD
  };

  # Ensure the NTFS data drive is mounted before ollama starts
  systemd.services.ollama.unitConfig.RequiresMountsFor = ["/mnt/Data"];

  services.open-webui = {
    enable = true;
    port = 8087; # same URL as the old docker setup
    environment = {
      TZ = "Europe/Amsterdam";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";

      # Keep connection settings driven by these env vars instead of the WebUI DB
      ENABLE_PERSISTENT_CONFIG = "False";
    };
  };

  # Start Open WebUI after its local backends
  systemd.services.open-webui = {
    after = ["ollama.service" "claude-api.service"];
    wants = ["ollama.service" "claude-api.service"];
  };
}
