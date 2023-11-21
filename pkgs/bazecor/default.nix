{ lib, appimageTools, fetchurl, polkit }:
let
  version = "1.3.6";
  pname = "bazecor";

  src = fetchurl {
    url = "https://github.com/Dygmalab/Bazecor/releases/download/v.${version}/Bazecor-${version}-x64.AppImage";
    hash = "sha256:1z7bzbr0h4ir7ylvvhi57aaw5z8h01g6bgzwflrz7j9503yd6gik";
  };

  appimageContents = appimageTools.extractType1 {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/usr/lib/bazecor/resources/app/.webpack/main/index.js --replace '/usr/bin/pkexec' '${polkit}/bin/pkexec'
    '';
  };

in
appimageTools.wrapType1 rec {
  inherit pname version src;

  extraInstallCommands = ''
    
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    cat $out/bin/${pname}
    install -m 444 -D ${appimageContents}/Bazecor.desktop $out/share/applications/Bazecor.desktop
    install -m 444 -D ${appimageContents}/bazecor.png $out/share/icons/hicolor/512x512/apps/bazecor.png
    substituteInPlace $out/share/applications/Bazecor.desktop \
      --replace 'Exec=Bazecor' 'Exec=${pname}'
  '';
}
