{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.session;
in {
	config = lib.mkIf (cfg.desktopEnvironment == "${moduleInfo.name}") {	
		services = {
			desktopManager.plasma6.enable=true;
			displayManager = {
				defaultSession = if (cfg.displayProtocol == "wayland")
					then "plasma"
					else "plasmax11";
			};
		};
		xdg.portal.extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
		
		# remove plasma bloat
		programs.kde-pim.enable = false;
		environment.plasma6.excludePackages = with pkgs.kdePackages; [
			kate
			konsole
			khelpcenter
			elisa
		];
	};
}
