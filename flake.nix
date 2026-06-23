{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    # home-manager.url = "github:nix-community/home-manager";

    home-manager = {
	url = "github:nix-community/home-manager/release-26.05";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
	let
		system = "x86_64-linux";
		myLib = import ./myLib { inherit self inputs; };
		# directory for homeManager
		homeDirectory = ./home;
	in 
	{
		nix.settings = {
			substituters = ["https://hyprland.cachix.org"];
			trusted-substituters = ["https://hyprland.cachix.org"];
			trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
			# Required so non-root users are allowed to use the above substituter/keys.
			# Use @wheel for all sudo users, or list your username explicitly.
			trusted-users = ["root" "@wheel"];
		};
		# declare hosts
		nixosConfigurations = {	
			nix-btw = myLib.mkHost {hostName = "nix-btw"; system = "x86_64-linux";};
		};

		# home manager configurations
		homeConfigurations."test" = home-manager.lib.homeManagerConfiguration {	
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};

			modules = [
				#./home/test/home.nix
				(homeDirectory + "/test/home.nix")
			];
		};
  	};
}
