{config, lib, pkgs, ...}:

{
	options.desktop = {
		env = lib.mkOption {
			type = lib.types.nullOr lib.types.str;
			description = "select DE";
			default = builtins.null;
		};
		displayProtocol = lib.mkOption {
			type  = lib.types.enum ["x11" "wayland"];
			description = "select display protocol";
			default = "wayland";
		};
	};

	imports = [
		./displayProtocol/x11.nix
		./displayProtocol/wayland.nix
		./KDE.nix
		./xfce.nix
		./hyprland.nix
	];

}
