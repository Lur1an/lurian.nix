{pkgs, ...}: {
  home.packages = with pkgs; [
    opencode
  ];
  home.file. ".opencode.json".text =
    builtins.toJSON
    {
    };
}
