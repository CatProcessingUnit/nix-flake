{config, pkgs, ...}:

{
   desktop.env = "KDE";
   desktop.displayProtocol = "wayland";
   boot.kernelPackages = pkgs.linuxPackages_zen;
   features.samba.enable = true;
   system.stateVersion = "26.05";

   features.zram = {
	enable = true;
	memoryPercent = 100;
   };
}
