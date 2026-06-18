# kde with wayland

{config, pkgs, ...}:

{
	services = {
		desktopManager.plasma6.enable=true;
	};
}
