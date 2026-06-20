{config, pkgs, lib, ...}:
{
	config = lib.mkIf (config.desktop.displayProtocol == "x11") {
		services.xserver = {
			enable = true;
		};
		services.displayManager.sddm = {
			enable = true;
		};
	};
}
