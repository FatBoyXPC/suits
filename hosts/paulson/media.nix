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

    nginx.virtualHosts."jf.fatboyxpc.com" = {
      locations."/" = {
        # https://jellyfin.org/docs/general/post-install/networking/
        proxyPass = "http://localhost:8096";
      };
    };
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
