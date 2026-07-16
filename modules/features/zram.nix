{config, pkgs, lib, ...}:

{
   options.myFlake.features.zram = {
	enable = lib.mkEnableOption "Enable zram";
	memoryPercent = lib.mkOption {
		type = lib.types.int;
		description = "zram size (%)";
		default = 50;
	};
   };
   config = lib.mkIf config.myFlake.features.zram.enable {
	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryPercent = config.myFlake.features.zram.memoryPercent;
		priority = 10;
	};
   };
}
