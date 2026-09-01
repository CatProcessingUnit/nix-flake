{myFlake, lib, pkgs, ...}:

{
	config = lib.mkIf (myFlake.desktop.env == "hyprland" ){
		home = {
			packages = with pkgs; [ 
				hyprpolkitagent
				hyprshutdown
			];
			file = {
				".config/hypr/hyprland.lua" = {
					source = (pkgs.replaceVars ./dotfiles/hypr/hyprland.lua {
						hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper";
						dbus-update-activation-environment = "${pkgs.dbus}/bin/dbus-update-activation-environment";
					});
				};
			};
		};
		services = {
			swaync = {
				enable = true;
			};
			hyprpaper = {
				enable = true;
			};
		};
		programs = {
			rofi = {
				enable = true;
			};
		};
		stylix = {
			targets.hyprland.hyprpaper.enable = true;
		};
	};
}
