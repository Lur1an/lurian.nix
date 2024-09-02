{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-multi-rtmp
      obs-pipewire-audio-capture
    ];
  };
  home.packages = with pkgs; [
    obs-studio-plugins.obs-multi-rtmp
    libcamera
  ];
}
