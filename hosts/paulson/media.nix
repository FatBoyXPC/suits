{ config, ... }:
{
  imports = [
    ./arr
  ];

  services = {
    jellyfin = {
      enable = true;
      group = "media";
    };
  };

  fat.proxy.jellyfin = {
    subdomain = "jf";
    target.port = 8096;

    unprotected = true;
  };

  # Let's make it so that seerr can see jellyfin (for authentication)
  networking.extraHosts = "192.168.2.48 jf.fatboyxpc.com";

  systemd.services.jellyfin = {
    unitConfig = {
      RequiresMountsFor = "/mnt/cosmos/media";
    };
  };
}

# vpn <<< wireguard.conf
