{config, lib, pkgs, myLib, ...}:

let
	mkModuleSelect = path: lib.types.enum
		(map 
			(e: lib.strings.removeSuffix ".nix" e.name) 
			(lib.attrsToList (builtins.readDir path))
		);
in {
	options.myFlake.session = {
		desktopEnvironment = lib.mkOption {
			type = lib.types.nullOr (mkModuleSelect ./desktopEnvironments);
			description = "select DE";
			default = builtins.null;
		};
		windowManager = lib.mkOption {
			type = lib.types.nullOr (mkModuleSelect ./windowManagers);
			description = "select a window manager";
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
		myLib.importAllFrom ./desktopEnvironments { inheritModuleInfo = true; } ++
		myLib.importAllFrom ./windowManagers { inheritModuleInfo = true; } ++
		myLib.importAllFrom ./displayProtocol { inheritModuleInfo = true; } ++
		myLib.importAllFrom ./displayManagers { inheritModuleInfo = true; };
	
}

