# Using the deploy command:

```shell
bash $ deploy
```

This will look at the hostname of the machine executing this command and call
`deploy hostname`.

```shell
bash $ deploy specter
```

This will deploy the `specter` configuration to the computer on the network
with the hostname of `specter`.

If the machine executing `deploy specter` does not have the hostname `specter`,
then `--target-host` is set to `specter`, `--build-host` is set
to `paulson`, and `--sudo` and `--use-subsitutes` are passed along as well.
Currently there are no plans to allow `--build-host` to be specified.

If the machine executing `deploy specter` has the hostname `specter`, then
`sudo` is passed to the front of the command and the following options are not
passed: `--target-host`, `--build-host`, `--sudo`, and `--use-subsitutes`. This
is so the build can happen completely locally.

If the target configuration and build machine have different OS types (nixos
vs darwin), an error is reported to not build remotely.

Lastly, we have a `--debug` option that will print out the full command that
would run.
