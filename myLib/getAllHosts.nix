# returns all hostnames from hosts directory

{self, lib, flakePaths, ...}:

let
   isDirectory = name: type:
   	if type == "directory" then
		true
	else builtins.trace "${name} is not an directory, skipping" false;

   hostDirectoryContents = builtins.readDir flakePaths.hosts;
   validHosts = lib.filterAttrs isDirectory hostDirectoryContents;

   # get names from validHosts attrSet
   getAllHosts = builtins.attrNames validHosts;
in
   getAllHosts
