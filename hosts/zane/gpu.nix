{ config, lib, pkgs, modulesPath, ... }:

# This file is almost a direct copy of the example here:
# https://nixos.wiki/wiki/Accelerated_Video_Playback
# Minus the overrides and intel-media-driver as I know my igpu is too old :)

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; }; # Force intel-vaapi-driver
}
