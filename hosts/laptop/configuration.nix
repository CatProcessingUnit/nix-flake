{config, pkgs, ...}:

{
   myFlake = {
	   desktop = {
		env = "i3";
		displayProtocol = "x11";
		displayManager = "ly";
	   };
	   users = {
		jac = {
			enable = true;
			isAdmin = true;
		};
	   };
	   features = {
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
   };
   boot.kernelPackages = pkgs.linuxPackages_zen;
   system.stateVersion = "26.05";
}
