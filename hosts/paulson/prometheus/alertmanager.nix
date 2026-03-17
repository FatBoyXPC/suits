{
  config,
  ...
}:
{
  imports = [
    ./../../../nixos-modules/ntfy-alertmanager.nix
  ];

  services = {
    ntfy-alertmanager = {
      enable = true;
      ntfy.topic = "fatboyxpc";
    };

    prometheus.alertmanager = {
      logLevel = "debug";
      enable = true;
      webExternalUrl = "http://alertmanager.fatboyxpc.com";
      configuration = {
        route = {
          receiver = "ntfy";
          routes = [
            {
              match.for = "jfly";
              receiver = "ntfy-jfly";
            }
          ];
        };
        receivers = [
          {
            name = "ntfy";
            webhook_configs = [
              {
                url = "http://localhost:${toString config.services.ntfy-alertmanager.port}";
              }
            ];
          }
          {
            name = "ntfy-jfly";
            webhook_configs = [
              {
                url = "http://localhost:${toString config.services.ntfy-alertmanager.port}?topic=jfly";
              }
            ];
          }
        ];
      };
    };

    nginx.virtualHosts."alertmanager.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.prometheus.alertmanager.port}";
      };
    };
  };
}
