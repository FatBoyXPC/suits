{ inputs, self', ... }:
{
  imports = [

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."james.lachance" = ./home.nix;
      home-manager.extraSpecialArgs = { inherit self'; };
    }
  ];

  networking.computerName = "hardman";
  networking.hostName = "hardman";
  networking.localHostName = "hardman";

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.openssh = {
    enable = true;
  };

  users.users."james.lachance" = {
    home = "/Users/james.lachance";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIId3HrH0wDaahWYCTZMKZeOWoRiacJIYJbek26vTEc1k fatboyxpc@gmail.com"
    ];
  };

  # Determinate uses its own daemon to manage the Nix installation that
  # conflicts with nix-darwin’s native Nix management.

  # This will allow you to use nix-darwin with Determinate. Some nix-darwin
  # functionality that relies on managing the Nix installation, like the
  # `nix.*` options to adjust Nix settings or configure a Linux builder,
  # will be unavailable.

  # To turn off nix-darwin’s management of the Nix installation, set:
  nix.enable = false;

  system.stateVersion = 7;
}
