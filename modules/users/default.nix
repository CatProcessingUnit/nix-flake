{config, lib, pkgs, myLib, flakePaths, ...}:
{
  #imports = [
  #  ./users/test.nix
  #];
  imports = myLib.importAllFrom ./users; 

  users.test.enable = lib.mkDefault true;

  # create home-manager module entries for existing users
  # by reading the contents of users directory
  # ignore if user doesn't have a home-manager module
  
  # it removes the need for adding the entries manually
  home-manager.users = let
  	removeFileExtension = name: lib.strings.removeSuffix ".nix" name;
	getHomeFolderPath = username: (flakePaths.home + "/${username}");
	hasHomeFolder = username: builtins.pathExists (getHomeFolderPath username);
	
	isModule = name: type: 
		let
			nameLength = builtins.stringLength name;
		in
			if (type == "regular") && ((builtins.substring (nameLength - 4) 4 name) == ".nix") then true
			else builtins.trace "${name} is not a module" false;


	userDirectoryContent = builtins.readDir ./users;
	userModules = builtins.attrNames (lib.filterAttrs isModule userDirectoryContent);
	userNames = map removeFileExtension userModules;
	usersWithHomeModules = lib.filter hasHomeFolder userNames;
	attrList = map (username: {name = username; value = import ((getHomeFolderPath username) + "/home.nix");}) usersWithHomeModules;
	attrSet = builtins.listToAttrs attrList;
  in attrSet;
}
