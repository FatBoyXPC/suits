{
  config,
  pkgs,
  ...
}:
{
  services.prometheus = {
    exporters.blackbox = {
      enable = true;

      configFile = pkgs.writeText "probes.yml" (
        builtins.toJSON {
          modules.http = {
            prober = "http";
            http = {
              method = "GET";
              preferred_ip_protocol = "ip4";
            };
          };
        }
      );
    };

    scrapeConfigs = [
      {
        job_name = "https_probes";
        metrics_path = "/probe";

        params.module = [ "http" ];

        static_configs = [
          {
            targets = [
              "http://localhost:8000"
            ];
          }
          {
            targets = [
              "https://healthcheck.snow.jflei.com"
            ];
            labels.for = "jfly";
          }
        ];

        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "localhost:${toString config.services.prometheus.exporters.blackbox.port}";
          }
        ];
      }
    ];

    ruleFiles = [
      (pkgs.writeText "critical_service_down_rule" (
        builtins.toJSON {
          groups = [
            {
              name = "critical_host_down";
              rules = [
                {
                  alert = "CriticalHostDown";
                  expr = "probe_success == 0";
                  for = "30s";
                  labels.severity = "error";
                  annotations = {
                    summary = "Critical host is down";
                    description = "The HTTP(S) probe for a critical service failed.";
                  };
                }
              ];
            }
          ];
        }
      ))
    ];
  };
}
