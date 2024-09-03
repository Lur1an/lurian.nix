{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = (with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
    ]) ++ [pkgs.obs-multi-rtmp];
  };
  home.packages = with pkgs; [
    obs-multi-rtmp
    libcamera
  ];
}
