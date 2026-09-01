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

	# for nvidia gpus
	environment.sessionVariables = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {	
		"LIBVA_DRIVER_NAME" = "nvidia";
		"__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
	};
   };
}
