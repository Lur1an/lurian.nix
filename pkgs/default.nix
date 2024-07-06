# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  pkgs, inputs,
}: rec {
  aider-chat = import ./aider-chat {dream2nix=inputs.dream2nix;};
}
