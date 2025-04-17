# pearson

As in Jessica Pearson! The trailblazer!

I stole this from @jfly's jflyso host

This produces a livecd environment that I can ssh to without having to touch anything.

## Build

```shell
nix build .#pearson-iso
```

## Burn and boot

To write it to a usb (you probably need `sudo` for this):

```shell
cp result/iso/nixos-*.iso /dev/[DEVICE]
```

Plug it into a machine, boot, and have fun hacking!

## No usb drive?

Try out netboot!

```shell
sudo nix run .#pearson-netboot
```
