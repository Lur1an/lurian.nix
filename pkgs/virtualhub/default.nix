{
  stdenv,
  fetchzip,
  autoPatchelfHook,
  libusb1,
  ...
}:
stdenv.mkDerivation rec {
  pname = "virtualhub";
  version = "66988";

  src = fetchzip {
    url = "https://www.yoctopuce.com/FR/downloads/VirtualHub.linux.${version}.zip";
    sha256 = "/YUe+/+08tDMoNosNh2jpQDTUSC8gWD8GYuT1U6E5+A=";
    stripRoot = false;
  };

  nativeBuildInputs = [autoPatchelfHook];

  buildInputs = [
    stdenv.cc.cc.lib
    libusb1
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 "64bits/VirtualHub" $out/bin/VirtualHub
  '';
}
