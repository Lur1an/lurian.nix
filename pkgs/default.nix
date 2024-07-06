# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}}: rec {
  # tree-sitter-langauges = pkgs.callPackage ./tree-sitter-languages.nix {};
  # grep_ast = pkgs.callPackage ./grep_ast.nix {};
  # aider-chat = pkgs.callPackage ./aider-chat {};
}
