{
  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIId3HrH0wDaahWYCTZMKZeOWoRiacJIYJbek26vTEc1k fatboyxpc@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
}
