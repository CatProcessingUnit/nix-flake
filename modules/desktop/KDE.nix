# kde with wayland

{config, pkgs, lib, ...}:

{
	config = lib.mkIf (config.desktop.env == "KDE") {
		services = {
			desktopManager.plasma6.enable=true;
		};
	};
}
