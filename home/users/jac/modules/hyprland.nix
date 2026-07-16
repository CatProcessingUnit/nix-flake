{myFlake, lib, pkgs, ...}:

{
	config = lib.mkIf (myFlake.desktop.env == "hyprland" ){
		wayland.windowManager.hyprland = {
			enable = true;
			extraConfig = ''	
				hl.bind(
					"SUPER + F",
					hl.dsp.exec_cmd("rofi -show drun")
				)
				--hl.on("hyprland.start", function ()
				--	hl.exec_cmd("hyprpaper")
				--end)
			'';

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
