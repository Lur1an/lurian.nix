{ 
stdenv
, fetchFromGitHub
, git
}:
stdenv.mkDerivation rec {
  pname = "illogical-icons";
  version = "unstable-${builtins.substring 0 8 src.rev}";

  src = fetchFromGitHub {
    owner = "end-4";
    repo = "OneUI4-Icons";
    rev = "master";
    sha256 = "f5t7VGPmD+CjZyWmhTtuhQjV87hCkKSCBksJzFa1x1Y="; # Replace with actual hash
  };

  nativeBuildInputs = [ git ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/share/icons
    for _i in OneUI OneUI-dark OneUI-light; do
      cp -r "$_i" "$out/share/icons/$_i"
    done
    
    runHook postInstall
  '';
}
