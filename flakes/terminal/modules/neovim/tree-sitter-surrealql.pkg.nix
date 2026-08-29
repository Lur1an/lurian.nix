{
  lib,
  fetchFromGitHub,
  tree-sitter,
}:
tree-sitter.buildGrammar {
  language = "surrealql";
  version = "0.0.0+rev=02f6d7f";
  generate = false;

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealql-tree-sitter";
    rev = "02f6d7fd3197d4ce6247dd23043f2a0e28122f32";
    hash = "sha256-OE7phPgZUHhYyso/n+xufGk3j9wfQIWZwF89Q2wR3fk=";
  };

  meta = {
    description = "Tree-sitter grammar for SurrealQL";
    homepage = "https://github.com/surrealdb/surrealql-tree-sitter";
    license = lib.licenses.asl20;
  };
}
