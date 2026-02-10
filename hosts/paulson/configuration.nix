{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules/james-user.nix
    ../../nixos-modules/single-ext4.nix
    #./gpu.nix
  ];

  boot.loader.systemd-boot.enable = true;

  disko.devices.disk.main.device = "/dev/disk/by-id/ata-ADATA_SU655_2L302LA1K6JC";

  networking.hostName = "paulson";

  time.timeZone = "America/New_York";

  services.openssh.enable = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
