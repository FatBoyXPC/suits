{
  lib,
  config,
  pkgs,
  ...
}:

{

  networking.hostName = "pearson";

  nixpkgs.hostPlatform = "x86_64-linux";

  # This is little more personal than "nixos".
  # The user is defined in the shared nixos module.
  services.getty.autologinUser = lib.mkForce "root";

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
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # WiFi
  networking.networkmanager.ensureProfiles.profiles.home = {
    connection.id = "The_Oxford_Hotel";
    connection.type = "wifi";
    connection.autoconnect = true;
    wifi.mode = "infrastructure";
    wifi.ssid = "The_Oxford_Hotel";
    #wifi-security.psk = "PeanutButterAndBananasOnToast!";
    #wifi-security.key-mgmt = "wpa-psk";
  };
}
