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
        inhibit_rules = [
          {
            source_matchers = [
              ''alertname="PangolinEntrypointDown"''
            ];
            target_matchers = [
              ''alertname=~"CriticalHostDown|NonCriticalHostDown"''
              ''dependency="pangolin"''
            ];
          }
        ];
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
  };

  fat.proxy.alertmanager = {
    name = "Alert Manager";
    target.port = config.services.prometheus.alertmanager.port;

    protected.lan = false;
  };

}
