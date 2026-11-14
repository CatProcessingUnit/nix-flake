{moduleInfo, ...}:
{config, lib, pkgs, ...}:
let
	cfg = config.myFlake.session;
in {
	config = lib.mkIf (cfg.windowManager == "${moduleInfo.name}") {
		programs.labwc.enable = true;
	};
}
