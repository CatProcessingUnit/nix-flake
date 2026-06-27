flake@{self, lib, inputs, flakePaths, ...}:

let 
   mkHost = {
   		hostName ? throw "hostname must be set", 
		system ? throw "system must be set",
	}: 
	lib.nixosSystem {
		# system = "x86_64-linux";
		# pass inputs to modules
		inherit system;
		specialArgs = {
			inherit inputs;
			inherit flakePaths;
			#inherit homeDirectory;
		};
		modules = with flakePaths; [
			{
				nixpkgs.config.allowUnfree = true;
				networking.hostName = hostName;
			}

			(hosts + "/${hostName}/configuration.nix")
			(hosts + "/${hostName}/hardware-configuration.nix")

			features
			users
			systemSettings
			desktop
			# imports home-manager module 
			inputs.home-manager.nixosModules.default 
			{
				home-manager = {
					useGlobalPkgs = true;
					useUserPackages = true;
				};	
			}
		];
	};
in
   mkHost
