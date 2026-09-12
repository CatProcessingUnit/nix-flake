{moduleInfo, ...}:
{lib, myLib, config, ...}:
let
	cfg = config.myFlake.features.${moduleInfo.name};
in {
	options.myFlake.features.${moduleInfo.name} = let
		# options shared between zram and zswap
		sharedOptions = name: {
			enable = lib.mkEnableOption "enable ${name}";
			memoryPercent = lib.mkOption {
				type = lib.types.int;
				default = 20;
				description = "Maximum total amount of memory that can be stored in ${name}";
			};
			algorithm = lib.mkOption {
				default = "zstd";
				description = "${name} algorithm";
			};
		};	
	in {
		zram = sharedOptions "zram";
		zswap = sharedOptions "zswap";
		fileSwap = {
			enable = lib.mkEnableOption "enable file swap";
			size = lib.mkOption {
				type = lib.types.int;
				default = 8;
				description = "File swap size (in GiB)";
			};
		};
	};
	
	imports = myLib.importAllFrom ./. { inheritModuleInfo = true; };
}
