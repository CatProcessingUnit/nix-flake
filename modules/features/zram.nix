{config, pkgs, lib, ...}:

{
   options = {
	features.zram.enable = lib.mkEnableOption "Enable zram";
	features.zram.memoryPercent = lib.mkOption {
		type = lib.types.int;
		description = "zram size (%)";
		default = 50;
	};
   };
   config = lib.mkIf config.features.zram.enable {
	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryPercent = config.features.zram.memoryPercent;
		priority = 10;
	};
   };
}
