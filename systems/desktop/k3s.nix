{pkgs, ...}: {
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://pi-master.local:6443";
    token = "luriank3s";
    package = pkgs.k3s_1_34;
  };
}
