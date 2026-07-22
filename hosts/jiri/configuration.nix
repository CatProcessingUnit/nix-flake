{pkgs, flakePaths, ...}:

{
   system.stateVersion = "26.11";
   boot.kernelPackages = pkgs.linuxPackages_zen;
   myFlake = {
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
   };
   stylix = {
	enable = true;
	base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
	image = (flakePaths.home + "/wallpapers/gruvbox-nix2.png");
	fonts = {
		sizes = {
			applications = 11;
			desktop = 9;
		};
	};
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
