{...}: {
  systemd.services.nginx.serviceConfig = {
    ProtectHome = false;
    ReadOnlyPaths = ["/home/lurian/.cache/wal"];
  };
  services.nginx = {
    enable = true;
    user = "lurian";
    group = "users";
    virtualHosts."localhost" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 7520;
        }
      ];
      locations = {
        "/" = {
          root = "/home/lurian/.cache/wal";
        };
      };
    };
  };
}
