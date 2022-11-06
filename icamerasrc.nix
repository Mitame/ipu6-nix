{ stdenv
, lib
, pkgs
, icamerasrc-src
, ipu6-camera-hal
, pkg-config
, gst_all_1
, autoreconfHook
, glib
, ...
}:
stdenv.mkDerivation {
  name = "icamerasrc";
  version = "0.0.0";

  src = icamerasrc-src;

  # Fix missing def
  CHROME_SLIM_CAMHAL = "ON";
  STRIP_VIRTUAL_CHANNEL_CAMHAL = "ON";

  # I think their autoconf settings assume the plugs will be in the same directory as the main gstreamer headers
  # which isn't true in Nix. I don't know autotools enough to patch it, so I'm just gonna hack this onto the end.
  CPPFLAGS = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gst_all_1.gst-plugins-base.dev
  ];

  buildInputs = with pkgs; [
    libdrm
  ];

  propagatedBuildInputs = [
    ipu6-camera-hal
  ];

  meta = with lib; {
    maintainers = [ maintainers.mitame ];
    license = [ licenses.lgpl21 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "Gstreamer src plugin 'icamerasrc'";
    homepage = "https://github.com/intel/icamerasrc/tree/icamerasrc_slim_api";
    longDescription = ''
      Support for MIPI cameras throughdd the IPU6 on Intel Tiger Lake and Alder Lake platforms.
    '';
  };
}
