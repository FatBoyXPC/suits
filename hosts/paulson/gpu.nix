# Settings from <https://wiki.nixos.org/wiki/Nvidia>
# Stoled this from:
# https://github.com/jfly/snow/blob/3131efdbfea969e05effb93f612a8bad6be088f4/machines/fflewddur/gpu.nix
{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
  };
}
