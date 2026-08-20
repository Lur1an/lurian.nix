# VulpineOS Container MCP Handoff

## Objective

Run VulpineOS as a persistent Docker system container on both NixOS machines and expose its browser tools to OpenCode as a local stdio MCP server.

The implementation should be declarative: Nix fetches the pinned release artifacts, builds the OCI image, and NixOS loads and manages the image. Do not require a manual `docker build` or `docker load` step.

## Worktree

- Branch: `feat/vulpineos-container`
- Path: `/mnt/Data/.treehouse/lurian.nix-32852c/1/lurian.nix`
- Treehouse lease: `6a3d79b605bb9311753823d0503a4d9c`
- Lease holder: `opencode:vulpineos-container`
- Base commit: `47987e2` (`remove AI api`)

The worktree lives on `/mnt/Data`, whose filesystem reports all files as executable. Worktree-specific Git configuration has therefore been set to `core.filemode=false`. Do not remove that setting.

The original worktree at `/home/lurian/lurian.nix` contains unrelated uncommitted changes. Do not copy, reset, or alter them as part of this work.

## User Decisions

- Enable VulpineOS on both `desktop` and `zephyrus` through shared configuration.
- Publish the VulpineOS web panel only on `127.0.0.1:8443`.
- Disable the existing Playwright MCP by default, while retaining its definition so downstream configuration can enable it.
- Use Docker as the OCI backend.
- Build and load the container through Nix rather than relying on an external registry image.

## Verified Upstream Behavior

Repository: <https://github.com/VulpineOS/VulpineOS>

VulpineOS provides two relevant modes:

```text
vulpineos serve
vulpineos mcp
```

`vulpineos serve` runs the persistent browser kernel and exposes VulpineOS's HTTP/WebSocket control plane. It does not expose MCP over HTTP.

`vulpineos mcp` is a stdio MCP server. It can either launch a local browser or connect to an existing VulpineOS server:

```text
vulpineos mcp --connect http://127.0.0.1:8443 --api-key KEY
```

The intended integration is therefore:

```text
OpenCode
  -> stdio MCP
  -> docker exec -i vulpineos vulpineos mcp --connect ...
  -> VulpineOS WebSocket control plane
  -> persistent Vulpine/Camoufox browser
```

The stock upstream Docker deployment is not directly usable as an OpenCode remote MCP server:

- Upstream publishes `Dockerfile.vulpinebox`, `docker-compose.yml`, and `scripts/entrypoint.sh`.
- No official ready-to-pull container image was found.
- The upstream image must be built locally.
- Its Dockerfile expects a prebuilt browser distribution under `dist/vulpine-linux/`.
- Its entrypoint always starts `vulpineos serve`.
- Port 8443 is VulpineOS's own control protocol, not MCP Streamable HTTP or SSE.

The upstream `serve` implementation accepts remote MCP bridge connections over its WebSocket server. The MCP bridge calls `Browser.enable` after connecting and then serves MCP JSON-RPC over stdin/stdout.

## Release State

The latest inspected release was `v0.1.8-dev.5`. It includes:

- `vulpineos-linux-amd64`
- `camoufox-150.0.2-beta.25-lin.x86_64.zip`

The browser archive is approximately 680 MB. Pin artifact URLs and hashes in Nix. Do not resolve `latest` during builds.

There are inconsistencies in upstream naming and documentation:

- Current documentation calls the browser Vulpine and describes Firefox 146.
- The inspected release artifact is named Camoufox 150.0.2 beta 25.
- Documentation alternates between 38 and 42 MCP tools.

Treat this as an immature upstream. Keep the version and browser artifact coupled and test the actual release combination before enabling the service.

## Recommended Nix Design

### 1. VulpineOS Package

Add `pkgs/vulpine/default.nix`.

It should:

- Fetch the pinned `vulpineos-linux-amd64` release binary with `fetchurl`.
- Fetch and unpack the matching browser archive with a fixed hash.
- Install the CLI and browser into one derivation or expose separate derivations if that makes patching clearer.
- Use `autoPatchelfHook` for the browser distribution.
- Use `patchelfUnstable` with `--no-clobber-old-sections`, matching the Nixpkgs `firefox-bin` packaging strategy.
- Preserve all browser-distribution files because Firefox expects adjacent resources and bundled libraries.

Likely runtime/build dependencies should be based on Nixpkgs `firefox-bin` plus upstream's Ubuntu Dockerfile:

```nix
alsa-lib
curl
dbus-glib
gtk3
libva
libxtst
nss
nspr
pciutils
pipewire
adwaita-icon-theme
```

Additional X11 libraries may be discovered by `autoPatchelfHook`. Resolve missing dependencies from build failures rather than adding a broad compatibility environment preemptively.

The upstream Dockerfile installs these Ubuntu packages:

```text
libgtk-3-0
libdbus-glib-1-2
libxt6
libasound2
libx11-xcb1
libxcomposite1
libxdamage1
libxrandr2
libxext6
libxfixes3
libxcursor1
libxi6
fonts-liberation
fonts-noto-color-emoji
xvfb
```

### 2. OCI Image

Add `pkgs/vulpine/image.nix` and export it from `pkgs/default.nix`.

Prefer `pkgs.dockerTools.streamLayeredImage` because the browser is large. `imageFile` is valid, but storing a complete image tar in addition to Docker's extracted layers creates unnecessary disk churn.

The image should contain only the required runtime closure:

- The packaged VulpineOS CLI and browser.
- `bash`, `coreutils`, and CA certificates.
- Xvfb if running the browser headful on a virtual display.
- Liberation and Noto emoji fonts.
- A generated entrypoint script.

Suggested image identity:

```nix
name = "vulpineos";
tag = "0.1.8-dev.5";
```

The image entrypoint should:

1. Start Xvfb on `:99` if headful mode is retained.
2. Resolve the packaged browser executable explicitly.
3. Execute `vulpineos serve` on port 8443.
4. Pass `--api-key "$VULPINE_API_KEY"`.
5. Use `exec` for correct signal handling.

Explicitly decide whether to run `--headless=true` or `--headless=false`. The upstream `serve` flag defaults to headless even though its Docker entrypoint also starts Xvfb, so upstream behavior is internally inconsistent. Start with upstream-compatible Xvfb plus `--headless=false`, then verify browser startup.

### 3. NixOS Module

Add `modules/vulpineos.nix`, import it from `modules/lurian.nix`, and enable it in shared configuration so both machines receive it.

Use:

```nix
virtualisation.oci-containers.backend = "docker";

virtualisation.oci-containers.containers.vulpineos = {
  image = "vulpineos:0.1.8-dev.5";
  imageStream = pkgs.vulpineos-image;
  ports = ["127.0.0.1:8443:8443"];
  environmentFiles = ["/var/lib/vulpineos/api.env"];
  volumes = [
    "/var/lib/vulpineos/data:/root/.vulpineos"
    "/var/lib/vulpineos/profiles:/opt/vulpineos/profiles"
  ];
  extraOptions = ["--shm-size=1g"];
};
```

The NixOS `oci-containers` module verifies that `imageStream` is supported. It streams the derivation into `docker load` before starting the service. The configured `image` and tag must exactly match the identity inside the image derivation or Docker will try to pull it from a registry.

Create persistent directories with systemd tmpfiles. They should not be world-readable.

Generate `/var/lib/vulpineos/api.env` once with a systemd oneshot service or activation-safe script. Requirements:

- Generate a cryptographically random key.
- Use the format `VULPINE_API_KEY=<hex>`.
- Set mode `0600` and ownership `root:root`.
- Never replace an existing key during rebuilds.
- Order the container service after the key-generation service.

Do not put the key in the Nix store.

The existing shared NixOS module already enables Docker and adds user `lurian` to the `docker` group.

### 4. OpenCode MCP Bridge

The current development version of the main worktree has `home-manager/terminal/mcp.nix`, but that file is not present at this worktree's base commit. Inspect the branch state before choosing whether to add it or integrate with the older OpenCode configuration. Do not copy unrelated uncommitted changes from the main worktree.

The target MCP definition should use a generated wrapper equivalent to:

```bash
exec docker exec -i vulpineos /bin/bash -lc \
  'exec /path/to/vulpineos mcp \
    --connect http://127.0.0.1:8443 \
    --api-key "$VULPINE_API_KEY"'
```

Important constraints:

- Keep stdin attached with `docker exec -i`.
- Do not use `-t`; a TTY corrupts MCP framing.
- Send diagnostics to stderr only.
- Let stdout contain only MCP JSON-RPC messages.
- Expand `VULPINE_API_KEY` inside the container so it is not embedded in OpenCode configuration or exposed as a host process argument.
- Give the container a stable name of `vulpineos`.

Register the wrapper as a local MCP server named `vulpineos`.

Disable Playwright by default but keep its server declaration available for downstream overrides.

OpenCode configuration is loaded only at startup. A full OpenCode restart is required after applying the Home Manager change.

### 5. Panel Key Helper

Because the local web panel requires the API key, provide a small helper such as `vulpineos-key` that executes:

```bash
```

The panel must only be reachable at <http://127.0.0.1:8443>. Do not publish it on `0.0.0.0`.

## Security Constraints

- Do not use privileged mode.
- Do not use host networking.
- Do not mount the Docker socket into the container.
- Only bind port 8443 to loopback.
- Keep the API key out of the Nix store and repository.
- Persist only VulpineOS state and browser profiles.
- Consider dropping capabilities only after validating Firefox sandbox behavior.
- The existing `docker` group is effectively root-equivalent; this work does not introduce that condition, but the MCP bridge relies on it.

## Validation Plan

1. Run `nix fmt`.
2. Build the VulpineOS package independently.
3. Run the packaged CLI with `--version`.
4. Inspect the browser executable and unresolved dynamic dependencies.
5. Build or stream the OCI image.
6. Load and start the image manually for an isolated smoke test if needed.
7. Verify `http://127.0.0.1:8443/health`.
8. Verify the panel is not reachable through a non-loopback interface.
9. Run the MCP wrapper and send an MCP `initialize` request.
10. Confirm the expected `vulpine_*` tools are listed.
11. Exercise `vulpine_new_context`, `vulpine_navigate`, and `vulpine_snapshot` against `https://example.com`.
12. Stop and restart the container and confirm state directories persist.
13. Evaluate or build both `.#desktop` and `.#zephyrus` configurations.
14. Restart OpenCode and confirm the VulpineOS tools are available while Playwright remains disabled.

## Useful Upstream References

- Repository README: <https://github.com/VulpineOS/VulpineOS>
- Dockerfile: <https://raw.githubusercontent.com/VulpineOS/VulpineOS/main/Dockerfile.vulpinebox>
- Compose file: <https://raw.githubusercontent.com/VulpineOS/VulpineOS/main/docker-compose.yml>
- Entrypoint: <https://raw.githubusercontent.com/VulpineOS/VulpineOS/main/scripts/entrypoint.sh>
- Docker documentation: <https://docs.vulpineos.com/docker>
- MCP tools: <https://docs.vulpineos.com/mcp-tools>
- OpenCode schema: <https://opencode.ai/config.json>
- NixOS OCI module: <https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/oci-containers.nix>
- Nixpkgs Firefox binary packaging: <https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/browsers/firefox-bin/default.nix>

## Treehouse Cleanup

When the branch is merged or no longer needed, release the worktree with:

```bash
treehouse return /mnt/Data/.treehouse/lurian.nix-32852c/1/lurian.nix
```
