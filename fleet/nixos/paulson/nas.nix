{
  imports = [
    ../../../nixos-modules/zfs
  ];

  # Mount various ZFS datasets. Note that `/mnt/cosmos` is *not* a parent dataset,
  # so any data in there will land on the rootfs. Don't put anything there! I
  # wonder if we could make it immutable somehow...
  fileSystems."/mnt/cosmos/archive" = {
    device = "cosmos/archive";
    fsType = "zfs";
    options = [
      # Don't block boot if we cannot mount this.
      "nofail"
      # But also do not allow anyone to write to the rootfs, even if the mount
      # fails (this will instead trigger another mount attempt).
      "x-systemd.automount"
    ];
  };
  fileSystems."/mnt/cosmos/backup" = {
    device = "cosmos/backup";
    fsType = "zfs";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };
  fileSystems."/mnt/cosmos/media" = {
    device = "cosmos/media";
    fsType = "zfs";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };
}
