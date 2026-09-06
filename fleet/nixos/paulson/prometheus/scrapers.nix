{
  config,
  ...
}:
{
  services.prometheus.scrapeConfigs = [
    {
      job_name = "prometheus";
      static_configs = [
        {
          targets = [ "localhost:${toString config.services.prometheus.port}" ];
        }
      ];
    }
    {
      job_name = "bitmagnet";
      static_configs = [
        {
          targets = [
            "${config.fat.proxy.bitmagnet.target.host}:${toString config.fat.proxy.bitmagnet.target.port}"
          ];
        }
      ];
    }
    {
      job_name = "node";
      static_configs = [
        {
          targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
        }
      ];
    }
    {
      job_name = "postgres";
      static_configs = [
        {
          targets = [ "localhost:${toString config.services.prometheus.exporters.postgres.port}" ];
        }
      ];
    }
  ];
}
