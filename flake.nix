{
  description = "New nixos configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";                   # Unstable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Stable Nix Packages

    # Home manager
    #home-manager.url = "github:nix-community/home-manager/master";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
    
    nur = {                                                               # NUR Community Packages
      url = "github:nix-community/NUR";                                   # Requires "nur.nixosModules.nur" to be added to the host modules
    };

    #nixgl = {                                                             # Fixes OpenGL With Other Distros.
    #  url = "github:guibou/nixGL";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;
    vars = {    # Variables Used In Flake
      user = "kamms";
      user_desc = "Kari Salokas";
      user_email = "kari.salokas@gmail.com";
      user_groups = [ "networkmanager" "wheel" "docker" "libvirtd" "input"];
      editor = "nano";
      systemname = "ukkonix";
      stateversion = "23.11";
      hm_stateversion = "23.11";
    };
    system = "x86_64-linux";
  in
  rec {
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      ${vars.systemname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit system inputs outputs vars;};
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager{
            home-manager = {
              useUserPackages = true;
              #useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs outputs vars;};
              users.${vars.user} = ./home-manager/home.nix;
            };
          }
        ];
      };
    };
  };
}

