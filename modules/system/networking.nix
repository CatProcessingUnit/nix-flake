{config, pkgs, lib, ...}:

{
   networking.networkmanager.enable = true;
   services = {
	avahi = {
		enable = true;
		nssmdns = true;
	};
	printing = {
		enable = true;
		drivers = with pkgs; [
			cnijfilter2
		];
	};
   };
}
