{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.features.swap.${moduleInfo.name};
in {
   options.myFlake.features.swap.${moduleInfo.name} = {
	memoryPercent = lib.mkOption {
		type = lib.types.int;
		description = "zram size (%)";
		default = 50;
	};
   };
   config = lib.mkIf cfg.enable {
	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryPercent = cfg.memoryPercent;
		priority = 10;
	};
   };
}
