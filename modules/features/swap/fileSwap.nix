{moduleInfo, ...}:
{config, ...}:

let
	cfg = config.myFlake.features.swap.${moduleInfo.name};
in {
	options.myFlake.features.swap.${moduleInfo.name} = {};
	config = builtins.trace "${moduleInfo.name} not implemented" {};
}
