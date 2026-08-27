{
  lib,
  fetchFromGitHub,
  tree-sitter,
}:
tree-sitter.buildGrammar {
  language = "verus";
  version = "0.0.0+rev=0c939ef";
  generate = false;

  src = fetchFromGitHub {
    owner = "secure-foundations";
    repo = "tree-sitter-verus";
    rev = "0c939ef2ec0a188c3cf24518474fb8082db02ec4";
    hash = "sha256-rwcoMYVwOg5Qwfn3rs/eDv9UmZbCvWa+VaJyEjP/wDQ=";
  };

  meta = {
    description = "Tree-sitter grammar for Verus";
    homepage = "https://github.com/secure-foundations/tree-sitter-verus";
    license = lib.licenses.mit;
  };
}
