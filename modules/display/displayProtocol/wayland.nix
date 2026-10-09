{moduleInfo, ...}:
{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayProtocol == moduleInfo.name) {
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
