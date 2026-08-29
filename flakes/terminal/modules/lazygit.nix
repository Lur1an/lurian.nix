{...}: {
  config.terminal.homeModule = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.lurian.terminal.lazygit.enable {
      programs.lazygit = {
        enable = true;
        settings = {
          promptToReturnFromSubprocess = false;
          os.editPreset = "nvim";
        };
      };
    };
  };
}
