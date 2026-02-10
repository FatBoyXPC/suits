{
  users.users.james = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfIbSq7RZCsuQY/Pn2q8taT2zVW6KbOOMLJh4/o2g7wUYYpOO6mqITVDWQjwGDrWyPo1HWGszjxSDLVlP/qlHUJhSI9LoubqvXNMaLBfu0LM9b79FSWjN/uvp3LgbBpUr/hP/8k2+yQnSeOcgEr16JWpiI36+dTKOtveD2voEm5OzVAmDH1uod2CI+9YBJibBjsOmVFqU0OYLziNss1U5m2mM4DvLSTdQiFtaOOGLqbtbRehQo/p2iKlZHXdkXQ2pbdHoepHm70JQkPWrcaMRKnAyjwmXkoC273RuT6ZqDft6pI02QmQTdUE365T+A2/tjCIZJRj7vDzVyFbsVXzsf"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
}
