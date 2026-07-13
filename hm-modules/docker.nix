{ pkgs, ... }:
{
  # This only exists in agnostic hm-modules because theoretically this could
  # be used for both linux and darwin. However, if I were to use docker on
  # linux, I would opt to use virtualisation.docker.enable = true;

  home.packages = with pkgs; [
    colima
    docker
    docker-compose
  ];

  services = {
    colima = {
      enable = true;

      profiles.default = {
        isActive = true;
        isService = true;
        setDockerHost = true;

        settings = {
          vmType = "vz";
          mountType = "virtiofs";
          cpu = 4;
          memory = 8;
        };
      };
    };
  };

  launchd.agents.colima-default.domain = "gui";
}
