{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.env == "LXQt") {
	services.xserver.desktopManager.lxqt.enable = true;
   	services.displayManager.defaultSession = "lxqt";
   };
}
