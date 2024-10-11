{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  libssh2,
  libevent,
  boehmgc,
  openssl,
  libyaml,
  pcre,
  gmp,
}: let
  pname = "hetzner-k3s";
in
  stdenv.mkDerivation {
    name = pname;

    src = fetchurl {
      url = "https://github.com/vitobotta/hetzner-k3s/releases/download/v2.0.8/hetzner-k3s-linux-amd64";
      sha256 = "1i6vvdyr1xqxywkqcvxbr89ahzksabpr6xgjki6zs49047l9zl32";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    # Specify runtime dependencies if needed
    buildInputs = [
      libssh2
      libevent
      boehmgc
      libyaml
      pcre
      gmp
      openssl
    ];

    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/${pname}
      chmod +x $out/bin/${pname}
    '';

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --prefix PATH : ${lib.makeBinPath [
        libssh2
        libevent
        boehmgc
        libyaml
        pcre
        gmp
        openssl
      ]} \
        --set SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt \
        --set SSL_CERT_DIR /etc/ssl/certs
    '';
  }
