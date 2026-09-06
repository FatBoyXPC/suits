{ config, lib, ... }:
let
  capitalize =
    s:
    let
      firstChar = lib.substring 0 1 s;
      rest = lib.substring 1 (builtins.stringLength s - 1) s;
    in
    lib.toUpper firstChar + rest;
in
{
  options.fat.proxy = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, name, ... }:
        {
          options = {
            unprotected = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            protected = {
              wan = lib.mkOption {
                type = lib.types.bool;
                default = !config.unprotected;
              };
              lan = lib.mkOption {
                type = lib.types.bool;
                default = !config.unprotected;
              };
            };
            subdomain = lib.mkOption {
              type = lib.types.str;
              default = name;
            };
            name = lib.mkOption {
              type = lib.types.str;
              default = capitalize name;
            };
            target = {
              host = lib.mkOption {
                type = lib.types.str;
                default = "localhost";
              };
              port = lib.mkOption {
                type = lib.types.port;
              };
            };
            alertPriority = lib.mkOption {
              type = lib.types.enum [
                "urgent"
                "error"
              ];
              default = "error";
            };
          };
        }
      )
    );
  };

  config = {
    services.newt.blueprint.public-resources = lib.mapAttrs (
      _: value:
      let
        enableAuth = value.protected.wan || value.protected.lan;
      in
      {
        auth = {
          sso-enabled = enableAuth;
        }
        // lib.optionalAttrs enableAuth {
          sso-roles = [ "Member" ];
        };

        full-domain = "${value.subdomain}.${config.services.pangolin.baseDomain}";
        name = value.name;
        protocol = "http";
        targets = [
          {
            hostname = value.target.host;
            method = "http";
            port = value.target.port;
          }
        ];
      }

      // lib.optionalAttrs (value.protected.wan && !value.protected.lan) {
        rules = [
          {
            action = "allow";
            match = "cidr";
            value = "192.168.2.1/24";
            priority = 1;
          }
        ];
      }
    ) config.fat.proxy;
  };
}
