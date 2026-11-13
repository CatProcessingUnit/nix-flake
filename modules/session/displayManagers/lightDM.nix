{moduleInfo, ...}:
{config, lib, ...}:

let
	cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.displayManager == "${moduleInfo.name}") {
	   services.xserver.displayManager.lightdm = {
		enable = true;
	   };
   };
}
