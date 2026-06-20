{config, pkgs, lib, ...}:
{
	config = lib.mkIf (config.desktop.displayProtocol == "wayland") {
		services.xserver.enable = true;
		programs.xwayland.enable = true;
		environment.systemPackages = with pkgs; [
			wl-clipboard
		];
		services.displayManager.sddm = {
			enable = true;
			wayland = {
				enable = true;
			};
		};
	};
}
