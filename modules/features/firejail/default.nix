{config, lib, ...}:

let
   cfg = config.myFlake.features.firejail;
in {
   options.myFlake.features.firejail = {
	enable = lib.mkEnableOption "enable firejail";
   };
   config = lib.mkIf cfg.enable {
	programs.firejail = {
		enable = true;
	};

	# local profiles
	environment.etc = let
		profiles = (builtins.filter
			(e: lib.strings.hasSuffix ".local" e)
			(map
				(e: e.name)
				(lib.attrsToList (builtins.readDir ./localProfiles)))
		);
	in
	builtins.listToAttrs
		(map
			(e: {
				name = "firejail/${e}"; 
				value = {
					text = builtins.readFile (./localProfiles + "/${e}");
				};
			})
			profiles);
   };
}
