rec {
  description = "Shit to deal with Intels NEW protocols";

  inputs = {
    ipu6-drivers-src = {
      url = "github:intel/ipu6-drivers";
      flake = false;
    };
    ipu6-camera-bins-src = {
      url = "github:intel/ipu6-camera-bins";
      flake = false;
    };
    ipu6-camera-hal-src = {
      url = "github:intel/ipu6-camera-hal";
      flake = false;
    };
    icamerasrc-src = {
      url = "github:intel/icamerasrc/icamerasrc_slim_api";
      flake = false;
    };
    ivsc-driver-src = {
      url = "github:intel/ivsc-driver";
      flake = false;
    };
    ivsc-firmware-src = {
      url = "github:intel/ivsc-firmware";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ipu6-drivers-src, ipu6-camera-bins-src, ipu6-camera-hal-src, icamerasrc-src, ivsc-driver-src, ivsc-firmware-src, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # Not sure why this can't be self.overlay but whatever
            self.overlay.${system}
          ];
        };
        # TODO: figure out how to make it available on all (most) kernels
        kernel = pkgs.linuxPackages_latest.kernel;
      in
      rec {
        packages = {
          ipu6-drivers = pkgs.callPackage ./ipu6-drivers.nix {
            inherit ipu6-drivers-src ivsc-driver-src kernel;
          };
          ipu6-camera-bins = pkgs.callPackage ./ipu6-camera-bins.nix {
            inherit ipu6-camera-bins-src;
          };
          ipu6-camera-hal = pkgs.callPackage ./ipu6-camera-hal.nix {
            inherit ipu6-camera-hal-src;
          };
          icamerasrc = pkgs.callPackage ./icamerasrc.nix {
            inherit icamerasrc-src;
          };
          ivsc-driver = pkgs.callPackage ./ivsc-driver.nix {
            inherit ivsc-driver-src kernel;
          };
          ivsc-firmware = pkgs.callPackage ./ivsc-firmware.nix {
            inherit ivsc-firmware-src;
          };
        };

        overlay = (final: prev: {
          inherit (self.packages.${system}) ipu6-drivers ipu6-camera-bins ipu6-camera-hal icamerasrc ivsc-driver ivsc-firmware;
        });

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
