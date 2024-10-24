{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    poetry
    pre-commit
    (python311Full.withPackages (ps:
      with ps; [
        pip
        watchfiles
        requests
        python-lsp-server
        pyserial
        pygobject3 # Python bindings for Glib
        gst-python # Python bindings for GStreamer
      ]))
  ];
}
