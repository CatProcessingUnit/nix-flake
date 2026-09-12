{moduleInfo, ...}:
{config, lib, ...}:
let
	cfg = config.myFlake.features.swap.${moduleInfo.name};
in {
	config = lib.mkIf (cfg.enable) {
		boot.zswap = {
			# config.swapDevices is empty when building a vm
			enable = if config.swapDevices != [] then true else builtins.warn "zswap requires file swap" false;
			maxPoolPercent = cfg.memoryPercent;
			compressor = cfg.algorithm;

			shrinkerEnabled = true;
		};
	};
}
