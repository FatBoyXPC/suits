{ config, lib, ... }:
let
  cfg = config.fat.initrd-ssh;
  identities = import ../shared-modules/identities.nix;
in
{
  options.fat.initrd-ssh = {
    # stolen from @jfly!
    # Does [NixOS Facter] have enough information to answer this question
    # rather than requiring the user to specify?
    # [NixOS Facter]: https://github.com/nix-community/nixos-facter
    networkKernelModule = lib.mkOption {
      type = lib.types.str;
      description = ''
        Kernel module to use in initrd to enable ethernet.
        Find out the required network card driver by running
        `nix shell nixpkgs#pciutils -c lspci -k` on the target machine. Look
        for "Ethernet controller" and the "Kernel driver in use".
      '';
    };
  };

  config = {
    boot.initrd.network.enable = true;
    boot.initrd.network.ssh = {
      enable = true;
      port = 22;
      authorizedKeys = [
        identities.james
      ];
      hostKeys = [ "/etc/secrets/ssh_host_key" ];
    };

    # Enable ethernet in initrd.
    boot.initrd.availableKernelModules = [ cfg.networkKernelModule ];
  };
}
