{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "mcp-excalidraw-server";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "yctimlin";
    repo = "mcp_excalidraw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nwZOV1U3wRJFuliixhtOkAD3rtmBF2rJ1z9kZ//0ARE=";
  };

  npmDepsHash = "sha256-XPssYU/4yo5sCfK3XByWPonhoGYDZIE6eESZvdHBjP0=";

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    node scripts/check-mcp-stdio.mjs
    node scripts/check-render.mjs
    runHook postCheck
  '';

  meta = {
    description = "Excalidraw MCP server and CLI with a live local canvas";
    homepage = "https://github.com/yctimlin/mcp_excalidraw";
    license = lib.licenses.mit;
    mainProgram = "mcp-excalidraw-server";
  };
})
