# returns all hostnames from hosts directory

{self, lib, flakePaths, ...}:

let
   requiredFiles = [ "configuration.nix" "hardware-configuration.nix" ];

   requiredFileCheck = hostPath: (
   	builtins.all 
		(fileName: 
			let
				filePath = (hostPath + "/${fileName}");
			in 
				if builtins.pathExists (hostPath + "/${fileName}") then true
				else throw "${filePath} is missing!"
		) 
		requiredFiles
	);

   isValidHost = name: type:
   	if type == "directory" then
		requiredFileCheck (flakePaths.hosts + "/${name}")
	else builtins.trace "${name} is not an directory, skipping" false;

   hostDirectoryContents = builtins.readDir flakePaths.hosts;
   validHosts = lib.filterAttrs isValidHost hostDirectoryContents;

   getAllHosts = builtins.attrNames validHosts;
in
   getAllHosts
