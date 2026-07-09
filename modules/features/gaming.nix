{pkgs, config, lib, ...}:

{
   options = {
	features.gaming.enable = lib.mkEnableOption "enable gaming";
   };
   config = lib.mkIf config.features.gaming.enable {
	programs = {
		steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			extraCompatPackages = with pkgs; [
				proton-ge-bin
			];
		};
		gamemode = {
			enable = true;
		};
	};
   };
}
