{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager";

    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
	url = "github:nix-community/stylix";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs: 
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
			display = modules + "/display";
		};
		myLib = import ./myLib { inherit self inputs flakePaths; };
	in 
	{	
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
  	};
}
