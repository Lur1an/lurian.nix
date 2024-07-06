{
  lib,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "aider-chat";
  version = "0.42.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "";
  };
}
