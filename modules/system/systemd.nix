{...}:

{
	systemd = {
		coredump = {
			enable = true; # required for the options below
			settings.Coredump = {
				Storage = "none";
				ProcessSizeMax = "0";
			};
		};
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
