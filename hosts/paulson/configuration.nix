{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./gpu.nix
    ./hardware-configuration.nix
    ./media.nix
    ../../nixos-modules/james-user.nix
    ../../nixos-modules/nix-index.nix
    ../../nixos-modules/single-ext4.nix
  ];

  boot.loader.systemd-boot.enable = true;

  disko.devices.disk.main.device = "/dev/disk/by-id/ata-ADATA_SU655_2L302LA1K6JC";

  networking = {
    hostName = "paulson";

    firewall.allowedTCPPorts = [
      53
      80
    ];

    firewall.allowedUDPPorts = [
      53
    ];
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        interface = [ "lo" "enp4s0" ];
        bind-interfaces = true;
        no-resolv = true;

        server = [
          "1.1.1.1"
          "8.8.8.8"

          "/www.fatboyxpc.com/1.1.1.1"
          "/www.fatboyxpc.com/8.8.8.8"
          "/pangolin.fatboyxpc.com/1.1.1.1"
          "/pangolin.fatboyxpc.com/8.8.8.8"
        ];

        address = [
          "/fatboyxpc.com/192.168.2.48"
        ];
      };
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
    };

    newt = {
      enable = true;
      environmentFile = "/etc/secrets/newt";
      settings.endpoint = "https://pangolin.fatboyxpc.com";
    };

    openssh.enable = true;
  };

  users = {
    groups.media.gid = 1000;
    users.james.extraGroups = [ "media" ];
  };

  time.timeZone = "America/New_York";

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
