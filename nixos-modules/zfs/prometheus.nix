{
  # Keep the list of exporters in sync with `scrapeConfigs` in `machines/fflewddur/prometheus/`.
  services.prometheus.exporters.zfs = {
    enable = true;
    openFirewall = true;
  };
}
