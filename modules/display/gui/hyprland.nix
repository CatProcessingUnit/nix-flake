{config, pkgs, lib, ...}: 

{
   config = lib.mkIf (config.desktop.env == "hyprland") {
	assertions = [
		{
			assertion = config.desktop.displayProtocol == "wayland";
			message = "only wayland is supported";
		}
	];

	programs.hyprland = {
	    enable = true; 
	};
   };
}
