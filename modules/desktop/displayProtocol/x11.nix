{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.desktop.displayProtocol == "x11") {
	services.xserver.enable = true;
	environment.systemPackages = with pkgs; [
		xclip
	];
   };
}
