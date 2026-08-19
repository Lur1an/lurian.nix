{pkgs, ...}: {
  systemd.services.opencode-web = {
    description = "OpenCode web server (LAN-accessible)";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];

    path = with pkgs; [
      # No-op xdg-open so `opencode web`'s browser auto-open does not error/spam
      # logs on this headless service.
      (writeShellScriptBin "xdg-open" "exit 0")
      bash
      coreutils
      git
      ripgrep
      gnused
      gnugrep
      findutils
      nodejs # node/npx for npx-based MCP servers
      uv # uvx for the nixos MCP
    ];

    environment = {
      HOME = "/home/lurian";
    };

    serviceConfig = {
      Type = "simple";
      User = "lurian";
      WorkingDirectory = "/home/lurian";
      ExecStart = "${pkgs.opencode}/bin/opencode web --port 4098 --hostname 0.0.0.0";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
