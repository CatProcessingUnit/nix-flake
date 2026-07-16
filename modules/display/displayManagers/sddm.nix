{config, pkgs, lib, ...}:
let
	isWayland = (config.myFlake.desktop.displayProtocol == "wayland");
	cfg = config.myFlake.desktop;
in {
	config = lib.mkIf (cfg.displayManager == "sddm") {
		services.displayManager.sddm = {
			enable = true;
			wayland = {
				enable = isWayland;
			};
		};
	};
}
