{moduleInfo, ...}:
{config, lib, ...}:

let
	cfg = config.myFlake.features.swap.${moduleInfo.name};
in {
	config = lib.mkIf (cfg.enable) {		
		swapDevices = builtins.trace "file swap enabled" [
			{
				device = "/.swapfile";
				size = cfg.size*1024;
			}
		  ];
	};
}
