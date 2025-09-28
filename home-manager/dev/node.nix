{pkgs, ...}: {
  home.packages = with pkgs; [
    bun
    nodejs
    tailwindcss
    typescript
    nodePackages_latest.pnpm
    nodePackages_latest.eslint_d
    nodePackages_latest.prettier
  ];
}
