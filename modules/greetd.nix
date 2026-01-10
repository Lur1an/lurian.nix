{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  # Prevents systemd messages from interrupting TUI
  services.greetd.useTextGreeter = true;

  # Ensure tuigreet is available
  environment.systemPackages = [pkgs.tuigreet];
}
