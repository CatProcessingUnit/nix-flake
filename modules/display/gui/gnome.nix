{config, lib, pkgs, ...}:

let
   cfg = config.myFlake.desktop;
in {
   config = lib.mkIf (cfg.env == "GNOME") {
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
