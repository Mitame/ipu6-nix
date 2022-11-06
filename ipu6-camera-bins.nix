{ stdenv, lib, ipu6-camera-bins-src, ... }:
let
  ipuVersion = "ipu6ep";
in
stdenv.mkDerivation rec {
  name = "ipu6-camera-bins-${version}";
  version = "0.0.0";

  src = ipu6-camera-bins-src;

  installPhase = ''
    mkdir $out
    mv ./${ipuVersion}/include $out/include
    mv ./${ipuVersion}/lib $out/lib
  '';

  meta = with lib; {
    maintainers = [ maintainers.mitame ];
    license = [ licenses.unfreeRedistributableFirmware ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "IPU firmware and proprietary image processing libraries";
    homepage = "https://github.com/intel/ipu6-camera-bins";
    longDescription = ''
      Firmware for MIPI cameras through the IPU6 on Intel Tiger Lake and Alder Lake platforms.
    '';
  };
}

