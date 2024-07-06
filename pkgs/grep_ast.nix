{
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pathspec,
  tree-sitter-languages,
}: let
in
  buildPythonPackage rec {
    pname = "grep-ast";
    version = "0.3.2";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "paul-gauthier";
      repo = pname;
      rev = "3cf620091364e95e501fa2fd1125cc9fae7971e5";
      hash = "sha256-xeHT8Zp1NyLeK2864DsFpNoxrct/EcUEbG+d33Gc/LQ=";
    };
    buildInputs = [
      setuptools
    ];
    propagatedBuildInputs = [
      pathspec
      tree-sitter-languages
    ];
    pythonImportsCheck = ["grep_ast"];
  }
