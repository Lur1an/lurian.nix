{
  lib,
  fetchFromGitHub,
  python312Packages,
}: let
  pythonPackages = python312Packages.overrideScope (_final: prev: {
    anyio = prev.anyio.overrideAttrs (old: {
      # Fix the test's invalid server-side SNI argument, without disabling tests.
      patches = (old.patches or []) ++ [./anyio-tls-test.patch];
    });
  });
in
  pythonPackages.buildPythonApplication {
    pname = "myfitnesspal-mcp";
    version = "1.0.0-unstable-2026-10-20";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "AdamWalt";
      repo = "myfitnesspal-mcp-python";
      rev = "3631ddb1d0d2dd71bf9688b62cba8befdbec24ab";
      hash = "sha256-IidMTkAExGpqUu3DKZchQk9JxQ8wzsVb39yxSxgms1U=";
    };

    # Only use explicitly supplied cookies; never inspect local browsers/keyrings.
    patches = [./environment-auth.patch];

    build-system = [pythonPackages.hatchling];
    dependencies = with pythonPackages; [
      browser-cookie3
      cryptography
      httpx
      keyring
      mcp
      myfitnesspal
      pint
      pydantic
    ];

    nativeCheckInputs = with pythonPackages; [pytestCheckHook];
    pythonImportsCheck = ["mfp_mcp.server"];

    meta = {
      description = "MyFitnessPal MCP server with explicit session-cookie authentication";
      homepage = "https://github.com/AdamWalt/myfitnesspal-mcp-python";
      license = lib.licenses.mit;
      mainProgram = "mfp-mcp";
      platforms = lib.platforms.linux;
    };
  }
