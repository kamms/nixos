{
  description = "New nixos configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";                   # Unstable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Stable Nix Packages

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
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
  } @ inputs: let
    inherit (self) outputs;
    vars = {    # Variables Used In Flake
      user = "kamms";
      user_desc = "Kari Salokas";
      user_groups = [ "networkmanager" "wheel" "docker" "libvirtd" "input"];
      editor = "nano";
      systemname = "ukkonix";
      stateversion = "23.11";
    };
  in {
    nixosConfigurations = {
      ${vars.systemname} = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs vars;};
        modules = [./nixos/configuration.nix];
      };
    };

    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "${vars.user}@${vars.systemname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; 
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}