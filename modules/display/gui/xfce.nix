{config, pkgs, lib, ...}:
	
{
	config = lib.mkIf (config.desktop.env == "xfce") {
		assertions = [
			{
				assertion = config.desktop.displayProtocol == "x11";
				message = "only x11 is supported";
			}
		];

		services.xserver.desktopManager = {
			xterm.enable = false;
			xfce.enable = true;
		};
		services.displayManager.defaultSession = "xfce";
	};
}
