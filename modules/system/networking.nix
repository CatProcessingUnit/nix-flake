{config, pkgs, lib, ...}:

{
   networking = {
	networkmanager.enable = true;
	nftables = {
		enable = true;
		tables = {
			"filter" = {
				family = "inet";
				content = ''
					chain output {
						type filter hook output priority 0;
					}
				'';
			};
		};
	};
   };
   services = {
	avahi = {
		enable = true;
		nssmdns4 = true;
	};
	printing = {
		enable = true;
		drivers = with pkgs; [
			cnijfilter2
		];
	};
   };
}
