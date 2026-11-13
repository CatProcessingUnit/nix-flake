{moduleInfo, ...}:
{config, pkgs, lib, ...}:
let
	cfg = config.myFlake.session;
	isWayland = (cfg.displayProtocol == "wayland");
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
