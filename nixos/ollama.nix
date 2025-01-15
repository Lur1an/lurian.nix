{pkgs, ...}: {
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

  environment.systemPackages = with pkgs; [
    ollama
    open-webui
  ];
}
