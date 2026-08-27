{callPackage}: {
  tree-sitter-verus = callPackage ./tree-sitter-verus.nix {};
  tree-sitter-surrealql = callPackage ./tree-sitter-surrealql.nix {};
  supermaven-agent = callPackage ./supermaven-agent.nix {};
}
