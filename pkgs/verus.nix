{
  lib,
  rustPlatform,
  rustToolchain,
  git,
  openssl,
  fetchgit,
  makeWrapper,
  pkg-config,
  writeShellScriptBin,
  z3,
}: let
  rev = "e7af09458c63821995e87fd1468731d54fc1c56d";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verus";
  version = "unstable-2026-09-12";

  src = fetchgit {
    url = "https://github.com/verus-lang/verus.git";
    rev = rev;
    hash = "sha256-MY24fAFErIcLzarm/MJTWwhbGjLSeq/H5JPx4pQgetY=";
    leaveDotGit = true;
  };

  cargoRoot = "source";
  cargoHash = "sha256-EjGj2Tdyjngjmf8eBZgEgTOOhHcO22EAnCOIlVJCQZc=";
  doCheck = false;

  rustupShim = writeShellScriptBin "rustup" ''
    if [ "$1" = "show" ] && [ "$2" = "active-toolchain" ]; then
      echo "1.98.1-x86_64-unknown-linux-gnu (default)"
      exit 0
    fi

    exit 1
  '';

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
    git
    finalAttrs.rustupShim
  ];

  # The vstd build invokes Verus, which requires an available Z3 executable.
  VERUS_Z3_PATH = "${z3}/bin/z3";
  VERUS_USE_RUSTUP = "0";
  CARGO = "${rustToolchain}/bin/cargo";
  RUSTC = "${rustToolchain}/bin/rustc";
  VARGO_BUILD_SHA = "e7af09458c63821995e87fd1468731d54fc1c56d";
  VARGO_BUILD_VERSION = "0.2026.09.11.e7af094";
  VARGO_TOOLCHAIN = "1.98.1-x86_64-unknown-linux-gnu";

  buildPhase = ''
    runHook preBuild

    cd source
    $CARGO build --release
    $CARGO run --release -p cargo-verus -- build --release --manifest-path vstd/Cargo.toml

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    cp -r target-verus/release/. $out/libexec/
    makeWrapper $out/libexec/verus $out/bin/verus \
      --set VERUS_Z3_PATH ${z3}/bin/z3 \
      --set VERUS_USE_RUSTUP 0
    makeWrapper $out/libexec/cargo-verus $out/bin/cargo-verus \
      --set CARGO ${rustToolchain}/bin/cargo \
      --set RUSTC ${rustToolchain}/bin/rustc \
      --set VERUS_USE_RUSTUP 0

    runHook postInstall
  '';

  meta = {
    description = "Verified Rust for low-level systems code";
    homepage = "https://github.com/verus-lang/verus";
    license = lib.licenses.mit;
    mainProgram = "verus";
    platforms = lib.platforms.linux;
  };
})
