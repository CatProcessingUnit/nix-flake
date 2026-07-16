{pkgs, config, lib, ...}: 

{
   config = lib.mkIf (config.desktop.env == "hyprland") {	
	programs.hyprland = {
		# includes desktop portal
		enable = true;
	};

	services = {
		displayManager.defaultSession = "hyprland";
		hyprpolkitagent.enable = true; # Authentication agent
	};
   };
}
