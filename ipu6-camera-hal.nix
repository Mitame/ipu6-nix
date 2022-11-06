{ stdenv
, lib
, ipu6-camera-hal-src
, expat
, cmake
, automake
, libtool
, pkg-config
, gst_all_1
, ipu6-camera-bins
, ...
}:
let
  ipuVersion = "ipu6ep";
in
stdenv.mkDerivation rec {
  name = "ipu6-camera-hal-${version}";
  version = "0.0.0";

  src = ipu6-camera-hal-src;

  NIX_CFLAGS_COMPILE = "-I${ipu6-camera-bins}/include/ia_camera -I${ipu6-camera-bins}/include/ia_cipf -I${ipu6-camera-bins}/include/ia_cipf_css -I${ipu6-camera-bins}/include/ia_imaging -I${ipu6-camera-bins}/include/ia_tools";

  nativeBuildInputs = [
    ipu6-camera-bins
    pkg-config
  ];

  buildInputs = [
    expat
    automake
    cmake
    libtool
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  propagatedBuildInputs = [
    ipu6-camera-bins
  ];

  patchPhase = ''
    # Remove slash from the end of prefix to avoid double slashes
    substituteInPlace cmake/libcamhal.pc.cmakein \
      --replace \''${prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace \''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DIPU_VER=${ipuVersion}"
    "-DENABLE_VIRTUAL_IPU_PIPE=OFF"
    "-DUSE_PG_LITE_PIPE=ON"
    "-DUSE_STATIC_GRAPH=OFF"
  ];

  meta = with lib; {
    maintainers = [ maintainers.mitame ];
    license = [ licenses.asl20 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu6-camera-hal";
    longDescription = ''
      Support for MIPI cameras throughdd the IPU6 on Intel Tiger Lake and Alder Lake platforms.
    '';
  };
}
