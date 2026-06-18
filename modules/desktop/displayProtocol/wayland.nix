{config, pkgs, ...}:
{
	environment.systemPackages = with pkgs; [
		wl-clipboard
	];
	services.displayManager.sddm = {
		enable = true;
		wayland = {
			enable = true;
		};
	};
}
