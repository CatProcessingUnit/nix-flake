{moduleInfo, ...}:
{config, lib, ...}:

let
	cfg = config.myFlake.features.swap.${moduleInfo.name};
in {
	options.myFlake.features.swap.${moduleInfo.name} = {
		size = lib.mkOption {
			type = lib.types.int;
			default = 8;
			description = "file swap size (in GB)";
		};
	};
	config = lib.mkIf (cfg.enable) {		
		swapDevices = builtins.trace "file swap enabled" [
			{
				device = "/.swapfile";
				size = cfg.size*1024;
			}
		  ];
	};
}
