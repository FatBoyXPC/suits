# Patterned off of https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD

{ self }:

let
  sys = self.nixosConfigurations.pearson.extendModules {
    modules = [
      (
        { modulesPath, ... }:
        {
          imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

          # The default compression algorithm produces the smallest images, but takes a *while*.
          isoImage.squashfsCompression = "gzip -Xcompression-level 1";
        }
      )
    ];
  };
in

sys.config.system.build.isoImage
