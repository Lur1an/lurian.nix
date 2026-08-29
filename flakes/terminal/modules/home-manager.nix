{
  config,
  lib,
  ...
}: {
  options.terminal.homeModule = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Merged terminal Home Manager module";
  };

  config.flake.homeModules.default = config.terminal.homeModule;
}
