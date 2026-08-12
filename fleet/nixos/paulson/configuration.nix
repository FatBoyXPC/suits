{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fat-proxy.nix
    ./gpu.nix
    ./grafana.nix
    ./hardware-configuration.nix
    ./media.nix
    ../../../nixos-modules/james-user.nix
    ./nas.nix
    ../../../nixos-modules/nix-index.nix
    ../../../nixos-modules/single-ext4.nix
    ../../../nixos-modules/zfs
    ./prometheus
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "pangolin"
        "nvidia-kernel-modules"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };

  boot.loader.systemd-boot.enable = true;

  disko.devices.disk.main.device = "/dev/disk/by-id/ata-ADATA_SU655_2L302LA1K6JC";

  networking = {
    hostId = "93a23331";
    hostName = "paulson";

    firewall.allowedUDPPorts = [ 21820 ];
  };

  services = {
    newt = {
      enable = true;
      environmentFile = "/etc/secrets/newt";
      settings.endpoint = "https://pangolin.fatboyxpc.com";
    };

    pangolin = {
      enable = true;
      baseDomain = "fatboyxpc.com";
      environmentFile = "/etc/secrets/pangolin.env";
      letsEncryptEmail = "fatboyxpc@gmail.com";
      openFirewall = true;
      package = pkgs.fosrl-pangolin.override {
        edition = "enterprise";
      };
    };

    openssh.enable = true;
  };

  fat.proxy.litt = {
    target = {
      host = "192.168.2.1";
      port = 80;
    };

    protected.lan = false;
    alertPriority = "urgent";
  };

  users = {
    groups.media.gid = 1000;
    users.james.extraGroups = [ "media" ];
  };

  time.timeZone = "America/New_York";

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
