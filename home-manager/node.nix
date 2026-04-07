{pkgs, ...}: {
  home.packages = with pkgs; [
    bun
    nodejs
    tailwindcss
    typescript
    pnpm
    eslint_d
    prettier
  ];
}
