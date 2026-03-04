{
  config, ...
}:

let
  mediaDir = "/mnt/cosmos/media";
in
{
  services = {
    bazarr.enable = true;

    jackett.enable = true;

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

    jellyseerr.enable = true;

    nginx.virtualHosts."seerr.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.jellyseerr.port}";
      };
    };

    radarr = {
      enable = true;
      group = "media";
    };

    nginx.virtualHosts."radarr.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.radarr.settings.server.port}";
      };
    };

    sonarr = {
      enable = true;
      group = "media";
    };

    nginx.virtualHosts."sonarr.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.sonarr.settings.server.port}";
      };
    };

    transmission = {
      enable = true;
      group = "media";
      settings = {
        download-dir = "${mediaDir}/torrents";
        incomplete-dir = "${config.services.transmission.settings.download-dir}/incomplete";
        ratio-limit-enabled = true;
      };
    };

    nginx.virtualHosts."transmission.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.transmission.settings.rpc-port}";
      };
    };
  };
}

# media group
# vpn
# gpu hardware acceleration
# jackett
