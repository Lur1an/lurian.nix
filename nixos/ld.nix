{pkgs}:
with pkgs; [
  stdenv.cc.cc
  glib
  glibc
  zlib
  libz
  fuse3
  icu
  zlib
  nss
  openssl
  udev
  curl
  expat
  nspr
  xorg.libxcb
]
