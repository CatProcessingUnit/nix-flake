{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.features.swap.${moduleInfo.name};
in {
	config = lib.mkIf (cfg.enable) {
		zramSwap = {
			enable = true;
			algorithm = cfg.algorithm;
			memoryPercent = cfg.memoryPercent;
			priority = 10;
		};
	   };
}
