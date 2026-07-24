# return a list of paths to all modules
# (or directories with default.nix inside)
# in a specified directory

# ignores default.nix

# it can be used to quickly import all modules
# inside default.nix, instead of manually
# importing everything


{lib, ...}:

let
   importAllFrom = path: {
   	# pass full file name and file name without .nix extension
	# to the nix module (in the moduleInfo attrset)
	# requires another argument header at the top in the module
	inheritModuleInfo ? false,
   }: let
	checkFile = file: 
		if file.type == "regular" then
			((lib.strings.hasSuffix ".nix" file.name) && (file.name != "default.nix"))
		else if file.type == "directory" then
			(builtins.pathExists (path + "/${file.name}/default.nix"))
		else false;
	# convert readDir output to a list
	# because filter doesn't work on attr sets
	pathContentList = lib.attrsets.mapAttrsToList 
		(k: v: {name = k; type = v;}) 
		(builtins.readDir path);
	validFiles = builtins.filter checkFile pathContentList;
	modules = map 
		(file:
			let
				filePath = (path + "/${file.name}");
			in if !inheritModuleInfo then filePath
			else (import filePath {
					moduleInfo = {
						fileName = file.name;
						name = lib.strings.removeSuffix ".nix" file.name;
					};
				}
			)
		) 
		validFiles;
   in modules;
in importAllFrom
