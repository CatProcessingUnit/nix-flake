{moduleInfo, ...}:
{config, lib, ...}:

let
	cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.displayManager == "${moduleInfo.name}") {
	services.displayManager.ly = {
		enable = true;
		x11Support = (cfg.displayProtocol == "x11");
	};
   };
}
