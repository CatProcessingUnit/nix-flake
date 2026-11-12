{pkgs, flakePaths, config, ...}:

{
   system.stateVersion = "26.11";
   boot = {
   	#kernelPackages = pkgs.linuxPackages_zen;
	kernelPackages = pkgs.linuxPackages_latest;
	kernelParams = [
		"pcie_aspm=off" # fixes system log spam
	];
   };
   services.scx-loader = {
   	enable = true;
	config = {
		default_sched = "scx_lavd";
	};
   };
   myFlake = {
	   users = {
		jac = {
			enable = true;
			isAdmin = true;
		};
	   };
	   desktop = {
		env = "plasma";
		displayProtocol = "wayland";
		displayManager = "ly";
	   };
	   features = {
	   	virtualisation = {
			enable = false;
		};
		gaming.enable = true;
		swap = {
			fileSwap = {
				enable = true;
				size = 8;
			};
			zswap = {
				enable = true;
				algorithm = "zstd";
			};
		};
	   };
   };
   stylix = {
	enable = true;
	base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
	image = (flakePaths.home + "/wallpapers/railroad-cat.png");
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
		package = config.boot.kernelPackages.nvidiaPackages.new_feature;
	};
   };
   services.xserver.videoDrivers = [ "nvidia" ]; 
}
