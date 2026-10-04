{...}:

{
	systemd = {
		coredump.enable = false;
	};
	services = {
		journald = {
			# store all logs in ram, and limit max size
			# stops it from wearing out my ssd
			settings = {
				Journal = {
					Storage = "volatile";
					SystemMaxUse = "0M";
					RuntimeMaxUse = "64M";
				};
			};
		};
	};
}
