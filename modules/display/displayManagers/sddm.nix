{moduleInfo, ...}:
{config, pkgs, lib, ...}:
let
	isWayland = (config.myFlake.desktop.displayProtocol == "wayland");
	cfg = config.myFlake.desktop;
in {
	config = lib.mkIf (cfg.displayManager == "${moduleInfo.name}") {
		services.displayManager.sddm = {
			enable = true;
			wayland = {
				enable = isWayland;
			};
		};
	};
}
