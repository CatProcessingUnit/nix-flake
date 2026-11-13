{moduleInfo, ...}:
{config, lib, pkgs, ...}:

let
   cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.desktopEnvironment == "${moduleInfo.name}") {
	services = {
		desktopManager = {
			gnome.enable = true;
		};
		gnome = {
			core-apps.enable = true;
			core-developer-tools.enable = false;
			games.enable = false;
		};
	};

	environment.systemPackages = with pkgs; [
		gnomeExtensions.appindicator # system tray icons
	];
   };
}
