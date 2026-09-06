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

  services.prometheus = {
    enable = true;
    retentionTime = "100y";

    exporters = {
      node.enable = true;
      postgres.enable = true;

      systemd = {
        enable = true;
        user = "root";
      };
    };

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

  fat.proxy.prometheus = {
    target.port = config.services.prometheus.port;

    protected.lan = false;
  };
}
