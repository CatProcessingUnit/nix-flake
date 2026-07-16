{config, pkgs, ...}:

{
   myFlake = {
	   desktop = {
		env = "i3";
		displayProtocol = "x11";
		displayManager = "ly";
	   };
	   users = {
		jac.enable = true;
	   };
	   features.zram = {
		enable = true;
		memoryPercent = 100;
	   };
   };
   boot.kernelPackages = pkgs.linuxPackages_zen;
   features.samba.enable = true;
   system.stateVersion = "26.05";
}
