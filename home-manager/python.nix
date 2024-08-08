{pkgs, ...}: {
  home.packages = with pkgs; [
    (python311.withPackages (ps:
      with ps; [
        pip
        material-color-utilities
        pywayland
        requests
        pygobject3 # Python bindings for Glib
        gst-python # Python bindings for GStreamer
      ]))
  ];
}
