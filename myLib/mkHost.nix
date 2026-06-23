flake@{self, lib, inputs, ...}:

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
			#inherit homeDirectory;
		};
		modules = [
			{
				#nixpkgs.config.allowUnfree = true;
				nixpkgs.config.allowUnfree = true;
				networking.hostName = hostName;
			}

			# host specific configuration
			#(./. + "/hosts/${hostName}/configuration.nix")
			#(./. + "/hosts/${hostName}/hardware-configuration.nix")
			( ../. + "/hosts/${hostName}/configuration.nix")
			( ../. + "/hosts/${hostName}/hardware-configuration.nix")

			(../modules/features)
			(../modules/users)
			(../modules/system)
			(../modules/desktop)
			
			# imports home-manager module 
			#inputs.home-manager.nixosModules.default 
			#{
			#	home-manager = {
			#		useGlobalPkgs = true;
			#		useUserPackages = true;
			#	};	
			#}
		];
	};
in
   mkHost
