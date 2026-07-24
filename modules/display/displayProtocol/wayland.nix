{moduleInfo, ...}:
{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayProtocol == moduleInfo.name) {
	services.xserver.enable = true;
	environment.systemPackages = with pkgs; [
		wl-clipboard
	];
	programs.xwayland.enable = true;
   };
}
