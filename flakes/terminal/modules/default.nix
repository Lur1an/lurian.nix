{inputs}: {
  imports = [
    ./api.nix
    ./fonts
    ./wal.nix
    ./matugen.nix
    ./ghostty
    ./tmux.nix
    ./opencode
    (import ./treehouse.nix {inherit inputs;})
    ./zsh
    (import ./omp {inherit inputs;})
    ./lazygit.nix
    (import ./neovim {inherit inputs;})
    ./neovim/theme.nix
    ./neovim/plugins.nix
    ./neovim/runtime.nix
    ./neovim/keymaps.nix
  ];
}
