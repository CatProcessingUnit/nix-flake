{moduleInfo, ...}:
{config, pkgs, lib, ...}:
	
{
	config = lib.mkIf (config.myFlake.desktop.env == "${moduleInfo.name}") {
		assertions = [
			{
				assertion = config.myFlake.desktop.displayProtocol == "x11";
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
