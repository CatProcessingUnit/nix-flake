{config, lib, ...}:

{
   config = lib.mkIf (config.desktop.displayManager == "ly") {
	services.displayManager.ly = {
		enable = true;
		x11Support = (config.desktop.displayProtocol == "x11");
	};
   };
}
