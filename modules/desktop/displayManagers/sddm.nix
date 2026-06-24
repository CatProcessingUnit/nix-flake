{config, pkgs, lib, ...}:
let
	isWayland = (config.desktop.displayProtocol == "wayland");
	cfg = config.desktop;
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
