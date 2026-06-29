{config, lib, ...}:

{
   config = lib.mkIf (config.desktop.displayManager == "lightDM") {
	   services.xserver.displayManager.lightdm = {
		enable = true;
	   };
   };
}
