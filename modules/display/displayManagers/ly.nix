{config, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayManager == "ly") {
	services.displayManager.ly = {
		enable = true;
		x11Support = (config.myFlake.desktop.displayProtocol == "x11");
	};
   };
}
