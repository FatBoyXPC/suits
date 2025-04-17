{
  lib,
  flake',
  flake,
  config,
  ...
}:

{

  networking.hostName = "pearson";

  nixpkgs.hostPlatform = "x86_64-linux";

  # This is little more personal than "nixos".
  # The user is defined in the shared nixos module.
  services.getty.autologinUser = lib.mkForce "pearson";

  # Enable ssh.
  services.openssh.enable = true;

  # Allow ssh as the root user. nixos-anywhere needs this:
  # <https://github.com/nix-community/nixos-anywhere/pull/293#pullrequestreview-1962541552>
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIId3HrH0wDaahWYCTZMKZeOWoRiacJIYJbek26vTEc1k fatboyxpc@gmail.com"
  ];

  system.stateVersion = config.system.nixos.release;

  # Some minimal config necessary to define a buildable machine.
  fileSystems."/".device = "/dev/null";
  boot.loader.systemd-boot.enable = true;

  # WiFi
  networking.wireless = {
    allowAuxiliaryImperativeNetworks = true;
    networks = {
      # Format:
      # "SSID".psk = "password";
    };
  };
}
