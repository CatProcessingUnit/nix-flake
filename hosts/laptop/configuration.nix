{config, pkgs, ...}:

{
   desktop.env = "LXQt";
   desktop.displayProtocol = "x11";
   
   features.ssh.enabled = true;
   features.samba.enabled = true;

   boot.kernelPackages = pkgs.linuxPackages_zen;

   system.stateVersion = "26.05";
}
