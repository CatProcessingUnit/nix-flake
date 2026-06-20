{config, pkgs, lib, ...}: 

{
   config = lib.mkIf (config.desktop.env == "hyprland") {
	programs.hyprland = {
	    enable = true; 
	};
   };
}
