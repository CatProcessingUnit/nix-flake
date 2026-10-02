{myFlake, lib, pkgs, stylix, config, ...}:

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
				".config/waybar/style.css" = {
					source = let
						colors = lib.lists.foldr
							(e: acc: ''${acc}
							@define-color ${e.name} #${e.value};'')
							""
							(builtins.filter (e: lib.hasPrefix "base0" e.name && builtins.stringLength e.name == 6) (lib.attrsToList config.lib.stylix.colors));
					in (pkgs.replaceVars ./dotfiles/waybar/style.css {
						stylixColorScheme = colors;
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
			waybar = {
				enable = true;
			};
		};
		stylix = {
			targets = {
				hyprland.hyprpaper.enable = true;
				waybar.enable = false;
			};
		};
	};
}
