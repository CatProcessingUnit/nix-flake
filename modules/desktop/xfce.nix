{config, pkgs, lib, ...}:
	
{
	config = lib.mkIf (config.desktop.env == "xfce") {
		services.xserver.desktopManager = {
			xterm.enable = false;
			xfce.enable = true;
		};
		services.displayManager.defaultSession = "xfce";
	};
}
