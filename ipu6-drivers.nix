{ pkgs, lib, stdenv, kernel, ipu6-drivers-src, ivsc-driver-src, ... }:
let
  kernelSrc = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation rec {
  name = "ipu6-drivers-${version}-${kernel.version}";
  version = "1.0.0";

  passthru.moduleName = "ipu6";
  src = ipu6-drivers-src;

  nativeBuildInputs = kernel.moduleBuildDependencies;
  propagatedBuildInputs = [
    pkgs.ivsc-driver
  ];

  buildFlags = [
    "KERNEL_SRC=${kernelSrc}"
    "KERNELRELEASE=${kernel.modDirVersion}"
  ];

  patchPhase = ''
    cp -r ${ivsc-driver-src}/{backport-include,drivers,include} .

    # For some reason, this copies with 555 instead of 755
    chmod -R 755 backport-include drivers include 
  '';

  installPhase = ''
    make -C ${kernelSrc} \
      M=$(pwd) \
      INSTALL_MOD_PATH=$out \
      modules_install

    cp -r include $out/
  '';

  meta = with lib; {
    maintainers = [ maintainers.mitame ];
    #license = [ licenses.gpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
    description = "Kernel drivers for the IPU and sensors";
    homepage = "https://github.com/intel/ipu6-drivers";
    longDescription = ''
      Drivers for HM11B1, OV01A1S, OV01A10, OV02C10, OV2740, HM2170 and HI556 sensors
    '';
  };

}
