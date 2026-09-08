{moduleInfo, ...}:
{lib, myLib, ...}:
let
	moduleList = lib.mapAttrsToList (k: v: k) (lib.filterAttrs (k: v: k != "default.nix" && v == "regular") (builtins.readDir ./.));
in {
	options.myFlake.features.${moduleInfo.name} = (builtins.listToAttrs (
			lib.map (
				e: 
					let
						optionName = lib.removeSuffix ".nix" e;
					in {
					name = optionName;
					value = {
						enable = lib.mkEnableOption "enable ${optionName}";
					};
				}
			) moduleList
		));

	imports = myLib.importAllFrom ./. { inheritModuleInfo = true; };
}
