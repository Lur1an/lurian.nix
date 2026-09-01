{stdenv}:
stdenv.mkDerivation {
  name = "lurianFonts";
  src = ./files;
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r $src/* $out/share/fonts
  '';
}
