# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{pkgs, ...}: {
  # Make sure ollama is installed
  environment.systemPackages = with pkgs; [
    ollama
  ];
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      open-webui = {
        image = "ghcr.io/open-webui/open-webui:main";
        environment = {
          "TZ" = "Europe/Amsterdam";
          "OLLAMA_API_BASE_URL" = "http://127.0.0.1:11434/api";
          "OLLAMA_BASE_URL" = "http://127.0.0.1:11434";
        };

        volumes = [
          "/home/lurian/.open-webui/data:/app/backend/data"
        ];

        ports = [
          "127.0.0.1:3000:8080"
        ];

        extraOptions = [
          "--name=open-webui"
          "--hostname=open-webui"
          "--network=host"
          "--add-host=host.containers.internal:host-gateway"
        ];
      };
    };
  };
  # Define the systemd service
  systemd.services.ollama = {
    description = "Ollama Service";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"]; # Add dependency
    requires = ["network-online.target"]; # Add strict dependency

    serviceConfig = {
      Type = "simple";
      User = "lurian"; # Replace with your username
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "always";
      RestartSec = 3;
    };
  };
}
