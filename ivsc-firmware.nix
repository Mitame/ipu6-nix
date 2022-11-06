{ stdenv, lib, ivsc-firmware-src, ...}: stdenv.mkDerivation {
  name = "ivsc-firmware";
  version = "0.0.0";

  src = ivsc-firmware-src;

  installPhase = ''
    # The files need to be moved such that
    # ./firmware/a.bin -> /lib/firmware/vsc/soc_a1_prod/a_prod.bin
    mkdir -p $out/lib/firmware/vsc/soc_a1_prod/
    for f in ./firmware/*.bin; do
      newName="$(basename $f)"
      newName="''${newName%%.bin}_prod.bin"
      mv "$f" "$out/lib/firmware/vsc/soc_a1_prod/$newName"
    done
  '';
  meta = with lib; {
    maintainers = [ maintainers.mitame ];
    license = [ licenses.unfreeRedistributableFirmware ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "firmware binaries for the ivsc chipset";
    homepage = "https://github.com/intel/ivsc-firmware";
    longDescription = ''
      Firmware for the Intel Vision Sensing Controller(IVSC) on Intel Alder Lake platforms
    '';
  };
 
}