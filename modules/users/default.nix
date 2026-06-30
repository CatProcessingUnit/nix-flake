# import all users and create
# options for enabling them
# also import all existing home configurations

{config, lib, pkgs, myLib, flakePaths, ...}:

let
   getUserHomeModule = username: flakePaths.home + "/${username}/home.nix";
   hasHomeModule = username: builtins.pathExists (getUserHomeModule username);
   isModule = name: type:
   	if (type == "regular") && (lib.strings.hasSuffix ".nix" name) then
		true
	else
		builtins.trace "${name} is not a module, skipping" false;
   mkUserEntry = username: {
	options = {
		users.${username}.enable = lib.mkEnableOption "Enable user ${username}";
	};
	config = import (./users + "/${username}.nix") { inherit pkgs username; };
   };
  
   userModules = lib.filterAttrs (k: v: isModule k v) (builtins.readDir ./users);
   usernames = map (entry: lib.strings.removeSuffix ".nix" entry) (builtins.attrNames userModules);
   usersWithHomeModules = builtins.filter (username: (hasHomeModule username)) usernames;
in {
   imports = map (username: (mkUserEntry username)) usernames;
   home-manager.users = builtins.listToAttrs
   	(map (username: {name = username; value = import (getUserHomeModule username);}) usersWithHomeModules);
}
