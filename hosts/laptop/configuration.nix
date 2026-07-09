{config, pkgs, ...}:

{
   desktop = {
	env = "i3";
	displayProtocol = "x11";
	displayManager = "lightDM";
   };
   users = {
	jac.enable = true;
   };
   boot.kernelPackages = pkgs.linuxPackages_zen;
   features.samba.enable = true;
   system.stateVersion = "26.05";

   features.zram = {
	enable = true;
	memoryPercent = 100;
   };
}
