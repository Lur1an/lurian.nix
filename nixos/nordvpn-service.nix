{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nordvpn = inputs.self.packages.${pkgs.system}.nordvpn;
in {
  environment.systemPackages = [nordvpn];
  users.groups.nordvpn = {};
  networking.firewall.allowedTCPPorts = [443];
  networking.firewall.allowedUDPPorts = [1194];
  networking.firewall.checkReversePath = false;
  systemd = {
    services.nordvpn = {
      description = "NordVPN daemon.";
      serviceConfig = {
        ExecStart = "${nordvpn}/bin/nordvpnd";
        ExecStartPre = ''
          ${pkgs.bash}/bin/bash -c '\
            mkdir -m 700 -p /var/lib/nordvpn; \
            if [ -z "$(ls -A /var/lib/nordvpn)" ]; then \
              cp -r ${nordvpn}/var/lib/nordvpn/* /var/lib/nordvpn; \
            fi'
        '';
        NonBlocking = true;
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "nordvpn";
        RuntimeDirectoryMode = "0750";
        Group = "nordvpn";
      };
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
    };
  };
}
