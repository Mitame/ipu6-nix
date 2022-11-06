{ lib, stdenv, kernel, ivsc-driver-src, ... }:
let
  kernelSrc = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation rec {
  name = "ivsc-driver-${version}-${kernel.version}";
  version = "0.0.0";

  passthru.moduleName = "intel_vsc";
  src = ivsc-driver-src;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  buildFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernelSrc}"
  ];

  installPhase = ''
    make -C ${kernelSrc} \
      M=$(pwd) \
      INSTALL_MOD_PATH=$out \
      modules_install

    mv include $out/include
  '';

  meta = with lib; {
    maintainers = [ maintainers.mitame ];
    license = [ licenses.gpl2Only ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
    description = "Intel Vision Sensing Controller (IVSC) Driver";
    homepage = "https://github.com/intel/ivsc-driver";
    longDescription = ''
      Drivers for Intel Vision Sensing Controller (IVSC) on Intel Alder Lake platforms.
    '';
  };
}
