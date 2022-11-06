rec {
  description = "Shit to deal with Intels NEW protocols";

  inputs = {
    ipu6-drivers-src = {
      url = "github:intel/ipu6-drivers";
      flake = false;
    };
    ivsc-driver-src = {
      url = "github:intel/ivsc-driver";
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
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ipu6-drivers-src, ivsc-driver-src, ipu6-camera-bins-src, ipu6-camera-hal-src, icamerasrc-src, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (super: self': {
              inherit (self.packages.${system}) ipu6-drivers ivsc-driver ipu6-camera-bins ipu6-camera-hal icamerasrc;
            })
          ];
        };
        kernel = pkgs.linux;
      in
      {
        packages = {
          ipu6-drivers = pkgs.callPackage ./ipu6-drivers.nix {
            inherit ipu6-drivers-src ivsc-driver-src kernel;
          };
          ivsc-driver = pkgs.callPackage ./ivsc-driver.nix {
            inherit ivsc-driver-src kernel;
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
        };
        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
