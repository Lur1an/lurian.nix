{
  config,
  pkgs,
  ...
}: {
  users.users.github-runner = {
    isNormalUser = true;
    extraGroups = ["docker"];
  };
  services.github-runners = {
    repricer = {
      enable = true;
      url = "https://github.com/Lur1an/repricer/";
      name = "repricer";
      user = "github-runner";
      tokenFile = "/home/lurian/.github-runner-pat";
      extraLabels = ["nix-phat"];
      extraPackages = with pkgs; [
        docker
        devenv
      ];
    };
  };
}
