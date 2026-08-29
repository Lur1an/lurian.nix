{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      tree-sitter-verus = pkgs.callPackage ./neovim/tree-sitter-verus.pkg.nix {};
      tree-sitter-surrealql = pkgs.callPackage ./neovim/tree-sitter-surrealql.pkg.nix {};
      omp-undo-redo = pkgs.callPackage ./omp/undo-redo.pkg.nix {};
    };
    formatter = pkgs.alejandra;
  };
}
