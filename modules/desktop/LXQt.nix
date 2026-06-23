{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.desktop.env == "LXQt") {
   	services.xserver.desktopManager.lxqt.enable = true;
   	services.displayManager.defaultSession = "lxqt";
   };
}
