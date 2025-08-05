{pkgs, ...}: {
  home.packages = with pkgs; [
    bun
    nodejs
    tailwindcss
    typescript
    nodePackages_latest.pnpm # Package manager
    nodePackages_latest.typescript-language-server # Typescript
    nodePackages_latest.eslint_d # JS linter
    nodePackages_latest.prettier # Formatter
  ];
}
