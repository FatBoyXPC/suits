{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # <<< TO DO: clean this shit up, stolen from dotfiles
    shtuff.url = "github:jfly/shtuff";
    with-alacritty.inputs.nixpkgs.follows = "nixpkgs";
    with-alacritty.url = "github:FatBoyXPC/with-alacritty";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      nixpkgs,
      disko,
      self,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      hosts = lib.filterAttrs (hostname: filetype: filetype == "directory") (builtins.readDir ./hosts);

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "slack"
            "steam"
            "steam-unwrapped"
            "uhk-agent"
          ];
      };
      specialArgs = {
        inherit inputs;
        inherit self;
        self'.packages = self.packages.x86_64-linux;
      };
      packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = pkgs.newScope specialArgs;
        directory = ./packages;
      };
    in
    {
      nixosConfigurations = builtins.mapAttrs (
        hostname: filetype:
        lib.nixosSystem {
          system = "x86_64-linux"; # <<< TODO: live in host rather than be hardcoded
          modules = [
            disko.nixosModules.disko # <<< TODO: hosts should be able to import things they need, such as disko
            (./hosts + "/${hostname}/configuration.nix")
          ];
          inherit specialArgs;
        }
      ) hosts;

      packages.x86_64-linux = packages; # <<< TODO: do not hardcode the system here, either!
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          pkgs.nixos-rebuild
          pkgs.nixfmt-tree
        ];
      };
    };
}
