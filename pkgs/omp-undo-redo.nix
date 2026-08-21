# Oh My Pi extension: /undo and /redo session navigation for OMP/Pi.
# Upstream: https://github.com/Baylar55/omp-undo-redo
# Consumed by home-manager/terminal/omp.nix, which symlinks this package into
# ~/.omp/agent/extensions/ where OMP's ambient extension discovery finds it via
# the package.json `omp.extensions` manifest.
{
  fetchzip,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "omp-undo-redo";
  version = "1.5.1";

  # npm tarball: zero runtime dependencies (host imports are type-only),
  # no lifecycle scripts; dist/ is plain ESM JavaScript.
  src = fetchzip {
    url = "https://registry.npmjs.org/@baylarsadigov/omp-undo-redo/-/omp-undo-redo-1.5.1.tgz";
    hash = "sha256-SA7d5b8Sozk/HXCW1v6XhGk2IE+uRCMPnBsbzjHNGw8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp -r . $out/lib/omp-undo-redo
    runHook postInstall
  '';
}
