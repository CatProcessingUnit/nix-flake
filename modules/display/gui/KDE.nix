# kde with wayland

{config, pkgs, lib, ...}:

{
	config = lib.mkIf (config.desktop.env == "KDE") {	
		services = {
			desktopManager.plasma6.enable=true;
			displayManager = {
				defaultSession = if (config.desktop.displayProtocol == "wayland")
					then "plasma"
					else "plasmax11";
			};
		};
		xdg.portal.extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
		environment.plasma6.excludePackages = with pkgs.kdePackages; [
			kate
			konsole
			khelpcenter
			elisa
		];
	};
}
