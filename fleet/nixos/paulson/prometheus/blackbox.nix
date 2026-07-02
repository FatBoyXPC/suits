{
  config,
  lib,
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
              "https://healthcheck.snow.jflei.com"
            ];
            labels.for = "jfly";
          }
          {
            targets = [
              "https://pangolin.${config.services.pangolin.baseDomain}"
            ];
            labels.pangolin = "true";
          }
          {
            targets = lib.mapAttrsToList (
              _: proxy: "https://${proxy.subdomain}.${config.services.pangolin.baseDomain}"
            ) (lib.filterAttrs (_: proxy: proxy.alertPriority == "urgent") config.fat.proxy);
            labels = {
              alertPriority = "urgent";
              dependency = "pangolin";
            };
          }
          {
            targets = lib.mapAttrsToList (
              _: proxy: "https://${proxy.subdomain}.${config.services.pangolin.baseDomain}"
            ) (lib.filterAttrs (_: proxy: proxy.alertPriority == "error") config.fat.proxy);
            labels = {
              alertPriority = "error";
              dependency = "pangolin";
            };
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
      (pkgs.writeText "hosts_down_rule" (
        builtins.toJSON {
          groups = [
            {
              name = "jfly_down";
              rules = [
                {
                  alert = "JflyDown";
                  expr = ''probe_success{for="jfly"} == 0'';
                  for = "30s";
                  labels.severity = "error";
                  annotations = {
                    summary = "Jfly is down";
                    description = "The HTTP(S) probe for Jfly failed.";
                  };
                }
              ];
            }
            {
              name = "pangolin_entrypoint_down";
              rules = [
                {
                  alert = "PangolinEntrypointDown";
                  expr = ''probe_success{pangolin="true"} == 0'';
                  for = "30s";
                  labels.severity = "urgent";
                  annotations = {
                    summary = "Pangolin entrypoint is down";
                    description = "The HTTP(S) probe for the Pangolin entrypoint failed.";
                  };
                }
              ];
            }
            {
              name = "critical_host_down";
              rules = [
                {
                  alert = "CriticalHostDown";
                  expr = ''probe_success{alertPriority="urgent"} == 0'';
                  for = "30s";
                  labels.severity = "urgent";
                  annotations = {
                    summary = "Critical host is down";
                    description = "The HTTP(S) probe for a critical host failed.";
                  };
                }
              ];
            }
            {
              name = "non_critical_hosts_down";
              rules = [
                {
                  alert = "NonCriticalHostDown";
                  expr = ''probe_success{alertPriority="error"} == 0'';
                  for = "30s";
                  labels.severity = "error";
                  annotations = {
                    summary = "Non-critical host down";
                    description = "The HTTP(S) probe for a non-critical host failed.";
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
