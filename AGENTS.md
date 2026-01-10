# AGENTS.md - AI Coding Agent Guidelines

This is a NixOS/nix-darwin configuration repository ("dotfiles") using Nix flakes.
It manages multiple systems, home-manager configs, custom packages, and dotfiles.

## MCP Tools
- Use the `deepwiki` MCP to investigate the open source project of the tool whenever necessary, this is a good starting point to understand what you need to configure and how the project works
- Use the `nixos` MCP to ask questions about nixos configurations, home manager modules, etc..

## Repository Structure

| Directory | Purpose |
|-----------|---------|
| `flake.nix` | Main entry point - flake inputs, outputs, system configs |
| `systems/` | Per-machine NixOS/Darwin configurations |
| `systems/desktop/` | Desktop PC (Nvidia, Steam, multi-monitor) |
| `systems/zephyrus/` | ASUS Zephyrus laptop (Nvidia Optimus) |
| `systems/macbook/` | macOS nix-darwin configuration |
| `home-manager/` | Home-manager modules (user-level config) |
| `home-manager/profiles/` | Per-machine home profiles (linux.nix, macos.nix, etc.) |
| `home-manager/hyprland/` | Hyprland window manager config |
| `home-manager/terminal/` | Terminal tools (zsh, tmux, ghostty, etc.) |
| `modules/` | Shared NixOS modules |
| `modules/lurian.nix` | Core shared system config |
| `overlays/` | Nixpkgs overlays |
| `pkgs/` | Custom Nix packages |
| `dotfiles/` | Non-Nix config files (nvim, opencode) |
| `dotfiles/nvim/` | Neovim configuration (NvChad-based) |

## Build Commands

### Apply NixOS Configuration
```bash
# Desktop
sudo nixos-rebuild switch --flake .#desktop

# Zephyrus laptop
sudo nixos-rebuild switch --flake .#zephyrus

# Shell alias (also cleans backups):
update .#desktop
```

### Apply macOS Configuration
```bash
darwin-rebuild switch --flake .#macbook
```

### Build a Specific Package
```bash
nix build .#lurianFonts
```

## Formatting and Linting

### Nix Files
```bash
# Format all Nix files with alejandra (configured in flake.nix)
nix fmt
```

### Other Languages (via Neovim conform.nvim)
- **Lua:** `stylua`
- **Python:** `ruff_format`, `isort`
- **TypeScript/JS/HTML/CSS/YAML/JSON:** `prettier`
- **Rust:** `rustfmt`

## Testing

This is a configuration repository - there are no automated tests.
Testing is done by applying configurations and verifying they work:

```bash
# Test build without switching
sudo nixos-rebuild build --flake .#desktop

# Test with switch
sudo nixos-rebuild switch --flake .#desktop
```

## Nix Code Style

### Module Structure
Use the standard NixOS module pattern with `options` and `config`:

```nix
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.myModule = {
    enable = lib.mkEnableOption "my module";
    setting = lib.mkOption {
      type = lib.types.str;
      default = "value";
      description = "Description here";
    };
  };

  config = lib.mkIf config.myModule.enable {
    # configuration here
  };
}
```

### Import Ordering
Function arguments first, then `let` bindings, then body:

```nix
{
  inputs,
  outputs,
  lib,
  config,
  machineConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;
  myVar = "value";
in {
  # module body
}
```

### Naming Conventions
- **Module options:** camelCase (`extraBinds`, `customWindowRules`)
- **Variables:** camelCase (`machineConfig`, `floatingWindow`)
- **File names:** kebab-case or lowercase (`hardware-configuration.nix`, `default.nix`)

### Formatting Rules
- **Indentation:** 2 spaces for Nix
- **Trailing commas:** Use in lists and attribute sets
- **No semicolons:** Nix uses expression-based syntax
- **Comments:** Single-line with `#`

```nix
# List packages with `with pkgs;` pattern
environment.systemPackages = with pkgs; [
  vim
  git
  curl
];
```

## Lua Code Style (Neovim)

### Plugin Configuration Pattern
Follow NvChad conventions:

```lua
{
  "plugin/name",
  lazy = false,
  dependencies = { "dep/name" },
  config = function()
    require("configs.pluginconfig")
  end,
  opts = {
    setting = "value",
  },
}
```

### Naming Conventions
- **Variables:** snake_case (`on_attach`, `harpoon_ui`)
- **Modules:** lowercase with dots (`configs.lspconfig`)
- **Indentation:** 4 spaces

### Keymapping Pattern
```lua
local map = vim.keymap.set

map("n", "<leader>fm", function()
  require("conform").format()
end, { desc = "Format with conform" })
```

## Error Handling

### Nix
- Use `lib.mkIf` for conditional configuration
- Use `lib.optionals` for conditional list items
- Use `assert` for hard requirements

```nix
config = lib.mkIf config.myModule.enable {
  packages = lib.optionals config.otherModule.enable [ pkgs.extra ];
};
```

### Lua
- Check for nil before accessing nested properties
- Use pcall for potentially failing requires

## Important Files

- `flake.nix` - Entry point, defines all inputs/outputs
- `flake.lock` - Pinned dependency versions
- `modules/lurian.nix` - Core shared configuration
- `home-manager/profiles/*.nix` - Per-machine home configs
- `dotfiles/nvim/lua/plugins/init.lua` - Neovim plugin list
- `dotfiles/nvim/lua/configs/*.lua` - Neovim plugin configs

## Symlinked Dotfiles

Some configs are symlinked from this repo to `~/.config/`:
- `dotfiles/nvim/` -> `~/.config/nvim`
- `dotfiles/opencode/` -> `~/.config/opencode`

Edits in these directories are immediately reflected.

## Common Patterns

### Adding a Package
```nix
# In a home-manager module
home.packages = with pkgs; [
  newPackage
];

# Or in a NixOS module
environment.systemPackages = with pkgs; [
  newPackage
];
```

### Adding a Home-Manager Module
1. Create file in `home-manager/category/module.nix`
2. Import in relevant profile (`home-manager/profiles/*.nix`)

### Adding a System Module
1. Create file in `modules/module.nix`
2. Import in system config (`systems/*/default.nix`)

## Do Not

- Edit files in `/nix/store/` - they are read-only
- Commit `flake.lock` changes without testing
- Use mutable state - prefer declarative configuration
- Forget to format with `nix fmt` before committing
