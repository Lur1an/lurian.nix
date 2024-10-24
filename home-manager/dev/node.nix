{pkgs, ...}: {
  home.packages = with pkgs; [
    bun
    nodejs
    tailwindcss
    typescript
    nodePackages.npm # Package manager
    nodePackages.pnpm # Package manager
    nodePackages.js-yaml
    nodePackages.node2nix
    nodePackages.live-server # Live server
    nodePackages.typescript-language-server # Typescript
    nodePackages_latest.eslint_d # JS linter
    nodePackages_latest.prettier # Formatter
  ];
}
