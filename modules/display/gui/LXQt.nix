{moduleInfo, ...}:
{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.env == "${moduleInfo.name}") {
	services.xserver.desktopManager.lxqt.enable = true;
   	services.displayManager.defaultSession = "lxqt";
   };
}
