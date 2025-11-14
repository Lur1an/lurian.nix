{
  inputs,
  outputs,
  ...
}: {
  users.users."lurian".home = "/Users/lurian";
  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lurian = import ../../home-manager/profiles/macos.nix;
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };

  homebrew = {
    enable = true;
    brews = [
      "ghostty"
    ];
  };

  services.karabiner-elements.enable = true;

  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
