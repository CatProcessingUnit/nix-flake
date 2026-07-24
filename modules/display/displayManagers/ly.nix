{moduleInfo, ...}:
{config, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayManager == "${moduleInfo.name}") {
	services.displayManager.ly = {
		enable = true;
		x11Support = (config.myFlake.desktop.displayProtocol == "x11");
	};
   };
}
