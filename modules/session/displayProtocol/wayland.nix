{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.displayProtocol == moduleInfo.name) {
	services.xserver.enable = true;
	environment = {
		systemPackages = with pkgs; [
			wl-clipboard
		];
		sessionVariables = {
			"NIXOS_OZONE_WL" = 1;
		};
	};
	programs.xwayland.enable = true;
   };
}
