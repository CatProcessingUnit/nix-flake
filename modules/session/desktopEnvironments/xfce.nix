{moduleInfo, ...}:
{config, pkgs, lib, ...}:
	
let
	cfg = config.myFlake.session;
in {
	config = lib.mkIf (cfg.desktopEnvironment == "${moduleInfo.name}") {
		assertions = [
			{
				assertion = cfg.displayProtocol == "x11";
				message = "only x11 is supported";
			}
		];

		services.xserver.desktopManager = {
			xterm.enable = false;
			xfce.enable = true;
		};
	};
}
