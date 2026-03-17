{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./alertmanager.nix
    ./blackbox.nix
    ./scrapers.nix
  ];

  services = {
    prometheus = {
      enable = true;
      retentionTime = "100y";

      exporters.node.enable = true;

      alertmanagers = [
        {
          scheme = "http";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.alertmanager.port}" ];
            }
          ];
        }
      ];
    };

    nginx.virtualHosts."prometheus.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.prometheus.port}";
      };
    };
  };
}
