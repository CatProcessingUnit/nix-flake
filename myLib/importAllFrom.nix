# return a list of paths to all modules
# (or directories with default.nix inside)
# in a specified directory

# ignores default.nix

# it can be used to quickly import all modules
# inside default.nix, instead of manually
# importing everything


{lib, ...}:

let
   importAllFrom = path: let
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
	paths = map (file: (path + "/${file.name}")) validFiles;
   in paths;
in importAllFrom
