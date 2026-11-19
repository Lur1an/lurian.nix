{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  git,
  lld,
  cmake,
  go,
  perl,
  pkg-config,
}: let
  # build.rs downloads these at build time; prefetch them for the sandbox.
  pdfium = fetchzip {
    url = "https://github.com/kognitos/pdfium-static/releases/download/chromium/7809/pdfium-linux-x64-static.tgz";
    hash = "sha256-reqrNPOREO4MxNfkS/Jfw4l6kLpzlQOqV/pfJZfQAgs=";
    stripRoot = false;
  };
  librustyV8 = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_simdutf_release_x86_64-unknown-linux-gnu.a.gz";
    hash = "sha256-9IdiyhDR8fxgWkQcWuQw7Izh6egPFNePvELLh4wwtHY=";
  };
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "donsetch";
    version = "5.5.5";

    src = fetchFromGitHub {
      owner = "dondai44423";
      repo = "donsetch";
      tag = "v${finalAttrs.version}";
      hash = "sha256-LpHsRytB+bdh8lJPwQTCYYpNKgQN/oMb8YY9K3hkM1E=";
    };

    cargoHash = "sha256-N7ow12l0JtbAaz4FPz9bXBhyVdr5LUmkmKL5EssU+o4=";

    nativeBuildInputs = [
      cmake
      git
      go
      lld
      perl
      pkg-config
      rustPlatform.bindgenHook
    ];

    dontUseCmakeConfigure = true;
    buildFeatures = ["http"];

    env = {
      DONSETCH_PDFIUM_DIR = pdfium;
      RUSTY_V8_ARCHIVE = librustyV8;
    };

    doCheck = false;

    meta = {
      description = "Web fetch, search, and crawl for AI agents";
      homepage = "https://github.com/dondai44423/donsetch";
      license = lib.licenses.agpl3Only;
      mainProgram = "donsetch";
      platforms = ["x86_64-linux"];
    };
  })
