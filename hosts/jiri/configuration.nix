{pkgs, config, ...}:

{
   boot.kernelPackages = pkgs.linuxPackages_zen;
   users = {
	jac.enable = true;
   };
   desktop = {
	env = "KDE";
	displayProtocol = "wayland";
	displayManager = "ly";
   };
   features = {
	gaming.enable = true;
   };

   # ----------NVIDIA DRIVERS----------
   hardware = {
	graphics.enable = true;
	nvidia = {
		open = true; # use open kernel modules
		modesetting.enable = true; # for wayland
	};
   };
   services.xserver.videoDrivers = [ "nvidia" ]; 
}
