{
  config,
  ...
}: {
  home.file = {
    ".mozilla/extra/index.js".source = ./index.js;
    ".mozilla/extra/protocol.js".source = ./protocol.js;
    ".mozilla/native-messaging-hosts/darkreader.json".text =
      builtins.toJSON
      {
        name = "darkreader";
        description = "custom darkreader native host for syncing with pywal";
        path = "${config.home.homeDirectory}/.mozilla/extra/index.js";
        type = "stdio";
        allowed_extensions = ["darkreader@alexhulbert.com"];
      };
  };
}
