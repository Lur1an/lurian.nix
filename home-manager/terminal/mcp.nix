{
  lib,
  pkgs,
  ...
}: {
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
