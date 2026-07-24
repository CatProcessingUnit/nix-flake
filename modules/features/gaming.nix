{moduleInfo, ...}:
{pkgs, config, lib, ...}:

{
   options.myFlake.features.${moduleInfo.name} = {
	enable = lib.mkEnableOption "enable gaming";
   };
   config = lib.mkIf config.myFlake.features.${moduleInfo.name}.enable {
	programs = {
		steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			#extraCompatPackages = with pkgs; [
				#proton-ge-bin
			#];
		};
		gamescope = {
			enable = true;
			capSysNice = true;
		};
		gamemode = {
			enable = true;
		};
	};
	environment.systemPackages = with pkgs; [
		protonup-qt
	];
   };
}
