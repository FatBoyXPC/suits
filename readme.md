Jeremy says I need a readme, so here we go!

### Provisioning a new machine:

Reference this if needed:
https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md

- Create the appropriate machine config files in the repo
- It might be wise to run `nixos-generate-config` (on the machine to be
    provisioned) to ensure an accurate hardware configuration
  - This will need to be copied back to the repo
- Ensure to `git add` all the appropriate things
- Run the nixos-anywhere command! (Last step, step 8)

##### nixos-anywhere command:

`nix run github:nix-community/nixos-anywhere -- --flake <path to configuration>#<configuration name> root@<ip address>`

Example:
```
nix run github:nix-community/nixos-anywhere -- --flake .#zane root@192.168.2.62
```

This can also be run without rebooting:
```
nix run github:nix-community/nixos-anywhere -- --flake .#zane root@192.168.2.62 --no-reboot
```

### Deploying changes to a machine:

With the use of the `deploy` script in the bin directory, we can simply call
the script with a target for the first argument, such as `deploy zane`.
