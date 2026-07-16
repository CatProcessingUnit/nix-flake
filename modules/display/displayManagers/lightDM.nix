{config, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayManager == "lightDM") {
	   services.xserver.displayManager.lightdm = {
		enable = true;
	   };
   };
}
