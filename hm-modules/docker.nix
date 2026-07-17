{ pkgs, ... }:
{
  # This only exists in agnostic hm-modules because theoretically this could
  # be used for both linux and darwin. However, if I were to use docker on
  # linux, I would opt to use virtualisation.docker.enable = true;

  home.packages = with pkgs; [
    docker
    docker-compose
  ];

  services.colima = {
    enable = true;

    profiles.default = {
      isActive = true;
      isService = true;
      setDockerHost = true;

      settings = {
        cpu = 4;
        memory = 8;
        vmType = "vz";
        mountInotify = true;
        mountType = "virtiofs";
      };
    };
  };

  launchd.agents.colima-default.domain = "gui";
}
