{config, pkgs, lib, ...}:

{
   options = {
	features.zram.enable = lib.mkEnableOption "Enable zram";
	features.zram.size = lib.mkOption {
		type = lib.types.int;
		description = "zram size (in GB)";
		default = 8;
	};
   };
   config = lib.mkIf config.features.zram.enable {
	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryMax = config.features.zram.size * 1024 * 1024 * 1024;
		priority = 10;
	};
   };
}
