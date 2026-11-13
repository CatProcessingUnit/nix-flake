{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.desktopEnvironment == "${moduleInfo.name}") {
	services.xserver.desktopManager.lxqt.enable = true;
   };
}
