{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.lurian.vulpineos;
in {
  options.lurian.vulpineos.enable = lib.mkEnableOption "the VulpineOS browser container";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers.vulpineos = {
      image = "vulpineos:${pkgs.vulpineos.imageTag}";
      imageStream = pkgs.vulpineos-image;
      pull = "never";
      ports = ["127.0.0.1:8443:8443"];
      environmentFiles = ["/var/lib/vulpineos/api.env"];
      volumes = [
        "/var/lib/vulpineos/data:/root/.vulpineos"
        "/var/lib/vulpineos/profiles:/opt/vulpineos/profiles"
      ];
      extraOptions = ["--shm-size=1g"];
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/vulpineos 0700 root root -"
      "d /var/lib/vulpineos/data 0700 root root -"
      "d /var/lib/vulpineos/profiles 0700 root root -"
    ];

    systemd.services = {
      vulpineos-secret = {
        description = "Generate the VulpineOS API key";
        wantedBy = ["docker-vulpineos.service"];
        before = ["docker-vulpineos.service"];
        serviceConfig = {
          Type = "oneshot";
          UMask = "0077";
        };
        path = [
          pkgs.coreutils
          pkgs.gnugrep
        ];
        script = ''
          set -euo pipefail
          key_file=/var/lib/vulpineos/api.env
          if [[ -e "$key_file" ]]; then
            if [[ ! -f "$key_file" || -L "$key_file" ]]; then
              echo "$key_file must be a regular file" >&2
              exit 1
            fi
            chmod 0600 "$key_file"
            chown root:root "$key_file"
            if [[ $(wc -l < "$key_file") -ne 1 ]] || ! grep -Eq '^VULPINE_API_KEY=[0-9a-f]{64}$' "$key_file"; then
              echo "$key_file has an invalid format" >&2
              exit 1
            fi
            exit 0
          fi

          tmp=$(mktemp /var/lib/vulpineos/.api.env.XXXXXX)
          trap 'rm -f "$tmp"' EXIT
          key=$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')
          printf 'VULPINE_API_KEY=%s\n' "$key" > "$tmp"
          chmod 0600 "$tmp"
          chown root:root "$tmp"
          mv "$tmp" "$key_file"
          trap - EXIT
        '';
      };

      docker-vulpineos = {
        requires = ["vulpineos-secret.service"];
        after = ["vulpineos-secret.service"];
        unitConfig.RequiresMountsFor = ["/var/lib/vulpineos"];
      };
    };
  };
}
