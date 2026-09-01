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
		wayland.windowManager.hyprland = {
			#enable = true;
			#package = null;
			extraConfig = ''
				--local env = {
				--	{"LIBVA_DRIVER_NAME", "nvidia"},
				--	{"__GLX_VENDOR_LIBRARY_NAME", "nvidia"}
				--}
				hl.config({
					general = {
						layout = "scroll"
					}
				})

				local mainMod = "SUPER"
				local binds = {
					{mainMod.." + R", hl.dsp.exec_cmd("rofi -show drun")},
					{mainMod.." + Q", hl.dsp.window.close()},
					{mainMod.." + T", hl.dsp.exec_cmd("kitty")}
				}

				for k,v in pairs(binds) do
					hl.bind(v[1],v[2])		
				end
				--hl.bind(
				--	"SUPER + F",
				--	hl.dsp.exec_cmd("rofi -show drun")
				--)
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
