{
  lib,
  pkgs,
  ...
}: let
  vulpineosMcp = pkgs.writeShellApplication {
    name = "vulpineos-mcp";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.docker
    ];
    text = ''
      for _ in $(seq 1 30); do
        if docker exec vulpineos /bin/curl -fsS http://127.0.0.1:8443/health >/dev/null 2>&1; then
          exec docker exec -i vulpineos /bin/bash -lc \
            'exec /bin/vulpineos mcp --connect http://127.0.0.1:8443 --api-key "$VULPINE_API_KEY"'
        fi
        sleep 1
      done

      echo "VulpineOS did not become ready within 30 seconds" >&2
      exit 1
    '';
  };
  vulpineosKey = pkgs.writeShellApplication {
    name = "vulpineos-key";
    runtimeInputs = [pkgs.docker];
    text = ''
      exec docker exec vulpineos /bin/bash -lc \
        'printf "%s\n" "$VULPINE_API_KEY"'
    '';
  };
in {
  home.packages = [
    vulpineosMcp
    vulpineosKey
  ];

  programs.mcp.servers.vulpineos = {
    command = lib.getExe vulpineosMcp;
    enabled = true;
  };

  programs.mcp = {
    enable = true;
    servers = {
      grafana = {
        command = lib.getExe pkgs.mcp-grafana;
        enabled = false;
      };

      deepwiki.url = "https://mcp.deepwiki.com/mcp";

      playwright = {
        command = lib.getExe pkgs.playwright-mcp;
        args = [
          "--isolated"
          "--browser=firefox"
          "--headless"
        ];
      };

      v0 = {
        command = "${pkgs.nodejs}/bin/npx";
        args = [
          "mcp-remote"
          "https://mcp.v0.dev"
          "--header"
          "Authorization: Bearer {env:V0_API_KEY}"
        ];
        enabled = false;
      };

      linear = {
        url = "https://mcp.linear.app/mcp";
        enabled = false;
      };

      notion = {
        url = "https://mcp.notion.com/mcp";
        enabled = false;
      };

      nixos = {
        command = "${pkgs.uv}/bin/uvx";
        args = ["mcp-nixos"];
      };
    };
  };
}
