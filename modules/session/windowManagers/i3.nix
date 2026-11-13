{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.windowManager == "${moduleInfo.name}") {
	assertions = [
		{
			assertion = (cfg.displayProtocol == "x11");
			message = "only x11 is supported on i3";
		}
	];
	xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
	services = {
		xserver = {
			windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu #application launcher
					i3status # status bar
					i3lock
				];
			};
		};
		displayManager.defaultSession = "none+i3";
	};
   };
}
