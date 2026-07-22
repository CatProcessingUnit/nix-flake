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
   };
}
