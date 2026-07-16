{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.myFlake.desktop.displayProtocol == "wayland") {
	services.xserver.enable = true;
	environment.systemPackages = with pkgs; [
		wl-clipboard
	];
	programs.xwayland.enable = true;
   };
}
