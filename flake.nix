{
  description = "My NixOS configuration(s) + various dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = 
    { 
      self, 
      nixpkgs, 
      disko, 
      home-manager, 
      ... 
    }:
    let
      makeSystem = 
        { 
          system,
          host 
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
  
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager

            ./hosts/${host}
          ];
        };

      homelabInstall = import ./homelab-install.nix {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        inherit self disko;
      };
    in
    {
      nixosConfigurations = {
        # Laptop
        alaska = makeSystem {
          system = "x86_64-linux";
          host = "alaska";
        };
  
        # Server
        siberia = makeSystem {
          system = "x86_64-linux";
          host = "siberia";
        };
  
        # RPI 4B 8G (TODO)
        # salmonberry = makeSystem {
        #  system = "aarch64-linux";
        #  host = "salmonberry";
        # };
      };
 
      apps.x86_64-linux.homelab-install = {
        type = "app";
        meta = "Install a homelab host";
        program = "${homelabInstall}/bin/homelab-install";
      };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
        # aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt;
      };
    };
}
