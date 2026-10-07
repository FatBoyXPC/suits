# Using disko-install to upgrade a drive in place

This is written with using zfs in mind, so some of these instructions may not apply to other filesystems.
It's certainly possible (probable?) that some instructions are missing for other filesystems.

### Prerequisites

The zpool(s) defined in the disko config should be different than the machine that
will be performing `disko-install`. This is because `disko-install` will import
the defined zpool(s). I'm not sure if `disko-install` is smart enough to rename
zpools at time of execution, but why risk dealing with it?


### Starting over!

This is titled as such because I ran `disko-install` already but I did not like
how things turned out (permissions got messed up). During this first time, after
`disko-install` finished I never ran `zpool export zroot` but I did disconnect
the drive to move it to `paulson`. Due to this, even after reconnecting the
drive to my laptop, I was unable to force zfs to export the pool (yes I tried
various commands and flags to force it to happen). I ended up rebooting to get
rid of the zpool.

I already put paulson into maintenance mode since it was "down" anyway (no need
for various things to download when it'll get 'undone' anyway)

#### Provision the drive

disko-install:
```sh
$ sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake .#paulson --disk root /dev/sda --extra-files decrypted-secrets/paulson/ /etc/secrets/
```

Notes:

`--disk root /dev/sda` - `root` refers to a disk specified in your disko configuration.

This copies the decrypted secrets so we don't have to immediately `rsync`
the secrets post install.

Check if datasets are mounted: (they probably are not if disko-install succeeded)
```sh
$ zfs list -o name,mounted,mountpoint
```

Mount the drive post install:
```sh
$ zfs -a
```

Note: probably not wise if already on a machine running zfs, modify accordingly.

Verify secrets exist:
```sh
$ ls -l /mnt/disko-install-root/etc/secrets/
```

rsync all the things:
```sh
$ sudo rsync -e "sudo -u james ssh" -aAXUHvP --rsync-path="sudo rsync" paulson:/etc/passwd /mnt/disko-install-root/etc/passwd
$ sudo rsync -e "sudo -u james ssh" -aAXUHvP --rsync-path="sudo rsync" paulson:/etc/group /mnt/disko-install-root/etc/group
$ sudo rsync -e "sudo -u james ssh" -aAXUHvP --rsync-path="sudo rsync" paulson:/var/lib/ /mnt/disko-install-root/var/lib/
```

Note: you might want to change the flags here.

export zpool: (so you don't hang when rebooting your machine next time and it cleanly boots in new machine)
```sh
$ sudo zpool export zroot
```

Swap drives!
