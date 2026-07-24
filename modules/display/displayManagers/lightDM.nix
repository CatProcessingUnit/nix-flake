{moduleInfo, ...}:
{config, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayManager == "${moduleInfo.name}") {
	   services.xserver.displayManager.lightdm = {
		enable = true;
	   };
   };
}
