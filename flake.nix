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
		
		# stores all paths
		# it makes changing the file layout faster
		flakePaths = rec {
			home = ./home; # directory for homeManager
			hosts = ./hosts; # directory for host configurations
			modules = ./modules;
			users = modules + "/users";
			features = modules + "/features";
			systemSettings = modules + "/system";
			desktop = modules + "/desktop";
		};
		myLib = import ./myLib { inherit self inputs flakePaths; };
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
		#nixosConfigurations = {	
		#	nix-btw = myLib.mkHost {hostName = "nix-btw"; system = "x86_64-linux";};
		#	laptop = myLib.mkHost {hostName = "laptop"; system = "x86_64-linux";};
		#};

		nixosConfigurations = let
			allHosts = myLib.getAllHosts;
			entryToAttrs = name: {
				inherit name;
				value = myLib.mkHost {hostName = name; system = "x86_64-linux";};
			};
			hostAttrs = map entryToAttrs allHosts;
			attrSet = builtins.listToAttrs hostAttrs;
		in attrSet;
		
		# home manager configurations
		homeConfigurations."test" = home-manager.lib.homeManagerConfiguration {	
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};

			modules = [
				#./home/test/home.nix
				(flakePaths.home + "/test/home.nix")
			];
		};
  	};
}
