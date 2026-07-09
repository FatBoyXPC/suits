{ pkgs, self', ... }:
{
  boot = {
    extraModulePackages = [
      self'.packages.nomachine-usb-kernel-module
    ];

    kernelModules = [ "nxusb" ];
  };

  environment.systemPackages = [
    pkgs.nomachine-client
  ];
}
