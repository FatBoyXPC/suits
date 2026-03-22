{
  config,
  ...
}:
{
  services = {
    grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";

            # We scrape with a frequency of 60s. Don't set this to anything lower
            # than that, or you'll get weird issues when zooming in on
            # dashboards, such as
            # <https://github.com/rfmoz/grafana-dashboards/issues/169>.
            # From <https://github.com/rfmoz/grafana-dashboards?tab=readme-ov-file#node-exporter-full>
            # > timeInterval in the Grafana data source has to be set
            # > accordingly to the > scrape_interval configured in Prometheus.
            # > [...] this is set with the attribute
            # > `jsonData.timeInterval`.
            jsonData.timeInterval = "60s";
          }
        ];
      };
      settings = {
        security.secret_key = "$_file{/etc/secrets/grafana_secret_key}";
        server = {
          http_port = 3100;
          root_url = "http://grafana.fatboyxpc.com";
        };
      };

    };

    nginx.virtualHosts."grafana.fatboyxpc.com" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.grafana.settings.server.http_port}";
      };
    };
  };
}
