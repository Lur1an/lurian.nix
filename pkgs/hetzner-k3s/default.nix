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
      url = "https://github.com/vitobotta/hetzner-k3s/releases/download/v2.2.4/hetzner-k3s-linux-amd64";
      sha256 = "cLwGmFlguuCOnLONc/UwNdDTyXhatATXkgS2NMdDwu4=";
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
