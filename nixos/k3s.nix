{
  config,
  pkgs,
  ...
}: {
  services.k3s = {
    package = pkgs.k3s_1_30;
    enable = true;
    role = "agent";
    token = "K10730cf4e30f81f7c38c2a0936d1bd5550cba0c33e5635f830fe59bad0530f327e::server:dab0ba8b99375e3aedb9f440acfb9b4e";
    serverAddr = "https://pi-master:6443";
  };

  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost";
  };
}
