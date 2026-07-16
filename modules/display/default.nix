{config, lib, pkgs, myLib, ...}:

{
	options.myFlake.desktop = {
		env = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			description = "select DE";
			default = builtins.null;
		};
		displayProtocol = lib.mkOption {
			type  = lib.types.nullOr (lib.types.enum ["x11" "wayland"]);
			description = "select display protocol";
			default = builtins.null;
		};
		displayManager = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			description = "select display manager";
			default = builtins.null;
		};
	};
	
	config.xdg.portal = {
		enable = true;
		config.common.default = "*";
	};

	imports = 
		myLib.importAllFrom ./gui ++
		myLib.importAllFrom ./displayProtocol ++
		myLib.importAllFrom ./displayManagers;
	
}

