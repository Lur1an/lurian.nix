{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      pi-coding-agent
    ];
  };
}
