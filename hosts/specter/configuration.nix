# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  self',
  inputs,
  ...
}:

{
  imports = [
    ./desktop.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixos-modules/single-ext4.nix
    ./polybar
    ./shell.nix
    #./gpu.nix

    #./kodi
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.james = ./home.nix;
    }
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
      ];

    permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };

  boot.loader.systemd-boot.enable = true;

  disko.devices.disk.main.device = "/dev/nvme0n1";

  networking.hostName = "specter"; # Define your hostname.

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # networking.proxy.default = "http://user:password@proxy:port/";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver

      # for steam:
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  programs.dconf.enable = true;
  programs.steam.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.james = {
    shell = pkgs.zsh;
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

  # Flakes!
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    darktable
    self'.packages.my-nix
    psmisc
    xorg.xbacklight
  ];

  services.getty.greetingLine = ''If found, please email fatboyxpc@gmail.com immediately! \l'';

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  services.openssh.enable = true;
  services.udisks2.enable = true;

  services.interception-tools =
    let
      mux = "${pkgs.interception-tools}/bin/mux";
      intercept = "${pkgs.interception-tools}/bin/intercept";
      uinput = "${pkgs.interception-tools}/bin/uinput";
      caps2esc = "${self'.packages.interception-k2k}/bin/caps2esc";
      print2superL = "${self'.packages.interception-k2k}/bin/print2superL";
    in
    {
      enable = true;
      # Note: stringified key names are found here: https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
      udevmonConfig = ''
        - CMD: ${mux} -c caps2esc

        # The `-d` passed to uinput creates a virtual keyboard on the fly that looks
        # like my laptop's keyboard. This is arguably kind of weird as these
        # events may have originated from a completely different type of
        # keyboard. (This is the "living dangerously" documentation from
        # https://gitlab.com/interception/linux/plugins/dual-function-keys#multiple-devices)
        # Note that things get even more complicated if you're interested in
        # "grabbing" the mouse and generating synthetic mouse events too.
        # Fortunately, we're not doing that, but this is useful reading
        # regardless:
        #   - https://gitlab.com/interception/linux/plugins/dual-function-keys/-/issues/31#note_725827382
        #   - https://gitlab.com/interception/linux/tools#hybrid-device-configurations
        - JOB: ${mux} -i caps2esc | ${caps2esc} -m 1 | ${print2superL} | ${uinput} -d /dev/input/by-path/platform-i8042-serio-0-event-kbd

        # Match devices that look like a mouse. Copied from
        # https://gitlab.com/interception/linux/plugins/dual-function-keys#multiple-devices
        # Note: this must go before the keyboard job, as my mouse bizarrely
        # (apparently this isn't so uncommon :() *does* have a bunch of keys
        # that make it look like a keyboard.
        - JOB: ${intercept} $DEVNODE | ${mux} -o caps2esc
          DEVICE:
            EVENTS:
              EV_REL: [REL_WHEEL]
              EV_KEY: [BTN_LEFT]

        # Match devices that look like a keyboard.
        - JOB: ${intercept} -g $DEVNODE | ${mux} -o caps2esc
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK]
      '';
    };

  #nix.gc = {
  #automatic = true;
  #dates = "weekly";
  #options = "--delete-older-than 30d";
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.gnupg.agent.enable = true;
  programs.ssh = {
    startAgent = true;
  };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
