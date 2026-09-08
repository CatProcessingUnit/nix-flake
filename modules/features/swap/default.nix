{moduleInfo, ...}:
{lib, myLib, config, ...}:
let
	moduleList = lib.mapAttrsToList (k: v: (lib.removeSuffix ".nix" k)) (lib.filterAttrs (k: v: k != "default.nix" && v == "regular") (builtins.readDir ./.));
in {
	options.myFlake.features.${moduleInfo.name} = (builtins.listToAttrs (
			lib.map (
				e: {
					name = e;
					value = {
						enable = lib.mkEnableOption "enable ${e}";
					};
				}
			) moduleList
		));

	config.assertions = [
		(let
			enabledSwapOptions = lib.lists.foldr (
				e: count:
					if config.myFlake.features.${moduleInfo.name}.${e}.enable then
						count + 1
					else
						count
			) 0 moduleList;
		in {

			assertion = enabledSwapOptions <= 1;
			message = "only 1 swap option can be active at a given time";
		})
	];

	imports = myLib.importAllFrom ./. { inheritModuleInfo = true; };
}
