{
  pkgs,
  vulpineos,
}: let
  browserExecutable = "${vulpineos}/lib/vulpineos/browser/camoufox-bin";
  entrypoint = pkgs.writeShellScriptBin "vulpineos-entrypoint" ''
    set -euo pipefail

    if [[ -z "''${VULPINE_API_KEY:-}" ]]; then
      echo "VULPINE_API_KEY is required" >&2
      exit 1
    fi

    rm -f /tmp/.X99-lock /tmp/.X11-unix/X99
    ${pkgs.xvfb}/bin/Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp -ac &
    xvfb_pid=$!
    trap 'kill "$xvfb_pid" 2>/dev/null || true' EXIT
    sleep 1

    if [[ ! -x ${browserExecutable} ]]; then
      echo "VulpineOS browser executable is missing" >&2
      exit 1
    fi

    mkdir -p /opt/vulpineos/profiles/default

    exec ${vulpineos}/bin/vulpineos serve \
      --binary ${browserExecutable} \
      --headless=false \
      --profile /opt/vulpineos/profiles/default \
      --host 0.0.0.0 \
      --port 8443 \
      --no-tls \
      --api-key "$VULPINE_API_KEY"
  '';

  root = pkgs.buildEnv {
    name = "vulpineos-image-root";
    paths = [
      pkgs.dockerTools.binSh
      pkgs.dockerTools.caCertificates
      pkgs.dockerTools.fakeNss
      pkgs.bash
      pkgs.coreutils
      pkgs.curl
      pkgs.fontconfig
      pkgs.liberation_ttf
      pkgs.noto-fonts-color-emoji
      pkgs.xvfb
      entrypoint
      vulpineos
    ];
    pathsToLink = [
      "/bin"
      "/etc"
      "/lib"
      "/share"
    ];
  };
in
  pkgs.dockerTools.streamLayeredImage {
    name = "vulpineos";
    tag = vulpineos.imageTag;
    maxLayers = 50;
    contents = [root];
    extraCommands = ''
      mkdir -p lib64
      ln -s ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 lib64/ld-linux-x86-64.so.2
      mkdir -p opt/vulpineos tmp
      chmod 1777 tmp
    '';

    config = {
      Entrypoint = ["/bin/vulpineos-entrypoint"];
      Env = [
        "DISPLAY=:99"
        "HOME=/root"
        "PATH=/bin"
        "LD_LIBRARY_PATH=${pkgs.glibc}/lib"
      ];
      WorkingDir = "/opt/vulpineos";
      ExposedPorts = {"8443/tcp" = {};};
    };
  }
