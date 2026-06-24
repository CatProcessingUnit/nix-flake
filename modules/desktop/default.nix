{config, lib, pkgs, ...}:

{
	options.desktop = {
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
	
	imports = [
		./displayProtocol
		./displayManagers
		./KDE.nix
		./xfce.nix
		./hyprland.nix
		./LXQt.nix
		./i3.nix
	];
}

