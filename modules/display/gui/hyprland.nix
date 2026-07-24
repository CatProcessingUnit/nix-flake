{moduleInfo, ...}:
{pkgs, config, lib, ...}: 

{
   config = lib.mkIf (config.myFlake.desktop.env == "${moduleInfo.name}") {	
	programs.hyprland = {
		# includes desktop portal
		enable = true;
	};

	services = {
		displayManager.defaultSession = "hyprland";
	};
   };
}
