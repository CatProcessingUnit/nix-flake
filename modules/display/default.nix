{config, lib, pkgs, myLib, ...}:

let
	mkModuleSelect = path: lib.types.enum
		(map 
			(e: lib.strings.removeSuffix ".nix" e.name) 
			(lib.attrsToList (builtins.readDir path))
		);
in {
	options.myFlake.desktop = {
		env = lib.mkOption {
			type = lib.types.nullOr (mkModuleSelect ./gui);
			description = "select DE";
			default = builtins.null;
		};
		displayProtocol = lib.mkOption {
			type  = lib.types.nullOr (mkModuleSelect ./displayProtocol);
			description = "select display protocol";
			default = builtins.null;
		};
		displayManager = lib.mkOption {
			type = lib.types.nullOr (mkModuleSelect ./displayManagers);
			description = "select display manager";
			default = builtins.null;
		};
	};
	
	config.xdg.portal = {
		enable = true;
		config.common.default = "*";
	};

	imports = 
		myLib.importAllFrom ./gui { inheritModuleInfo = true; } ++
		myLib.importAllFrom ./displayProtocol { inheritModuleInfo = true; } ++
		myLib.importAllFrom ./displayManagers { inheritModuleInfo = true; };
	
}

