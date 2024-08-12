{...}: {
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        ui = {
          skin = "matugen";
        };
        refreshRate = "2s";
        readOnly = true;
        logoless = true;
      };
    };
  };
}
