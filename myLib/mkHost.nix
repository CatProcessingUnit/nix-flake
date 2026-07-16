flake@{self, lib, inputs, flakePaths, myLib, ...}:

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
			inherit myLib;
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
			display

			inputs.stylix.nixosModules.stylix
			# imports home-manager module 
			inputs.home-manager.nixosModules.default 
			({config, ...}: {
				home-manager = {
					useGlobalPkgs = true;
					useUserPackages = true;
					backupFileExtension = "backup";
					extraSpecialArgs = {
						myFlake = config.myFlake;
						inherit myLib;
					};
				};	
			})
		];
	};
in
   mkHost
