{
  grep_ast,
  buildPythonApplication,
  fetchFromGitHub,
  configargparse,
  gitpython,
  openai,
  tiktoken,
  jsonschema,
  rich,
  prompt-toolkit,
  numpy,
  scipy,
  backoff,
  pathspec,
  networkx,
  diskcache,
  packaging,
  sounddevice,
  soundfile,
  beautifulsoup4,
  pyyaml,
  pillow,
  diff-match-patch,
  playwright,
  pypandoc,
  httpx,
  litellm,
  streamlit,
}:
buildPythonApplication {
  pname = "aider";
  version = "0.42.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "paul-gauthier";
    repo = "aider";
    rev = "v0.42.0";
    sha256 = "sha256-VDz5o8KqiDQ5QBvYA4IKG4DYhKqapzjgq6VsMs+GV+s=";
  };

  propagatedBuildInputs = [
    configargparse
    gitpython
    openai
    tiktoken
    jsonschema
    rich
    prompt-toolkit
    numpy
    scipy
    backoff
    pathspec
    networkx
    diskcache
    grep_ast
    packaging
    sounddevice
    soundfile
    beautifulsoup4
    pyyaml
    pillow
    diff-match-patch
    playwright
    pypandoc
    httpx
    litellm
    streamlit
  ];
  # No tests
  doCheck = false;
}
