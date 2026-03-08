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
}

# vpn <<< wireguard.conf
