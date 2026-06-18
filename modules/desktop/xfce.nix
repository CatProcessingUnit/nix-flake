{config, pkgs, displayProtocol, ...}:


if displayProtocol == "wayland" then
	throw "wayland not supported"
else	
{
	services.xserver.desktopManager = {
		xterm.enable = false;
		xfce.enable = true;
	};
	services.displayManager.defaultSession = "xfce";
}
