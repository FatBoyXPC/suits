Jeremy says I need a readme, so here we go!

### Provisioning a new machine:

Reference [nixos-anywhere quickstart](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md) if needed:

- Create the appropriate machine config files in the repo
- Ensure to `git add` all the appropriate things
- Read pearson's readme and boot from iso or netboot!
- Run the `takeover` script!

  This ends up running `nixos-anywhere` from the last step in the quickstart.
  This forwards all arguments after the host to the `nixos-anywhere` command.

  Example:
  ```
  takeover zane
  ```

  This can also be run without rebooting:
  ```
  takeover zane --no-reboot
  ```

### Deploying changes to a machine:

With the use of the `deploy` script in the bin directory, we can simply call
the script with a target for the first argument, such as `deploy zane`.
