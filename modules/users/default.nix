# import all users and create
# options for enabling them

{config, lib, pkgs, myLib, flakePaths, ...}:

let
   isModule = name: type:
   	if (type == "regular") && (lib.strings.hasSuffix ".nix" name) then
		true
	else
		builtins.trace "${name} is not a module, skipping" false;
   mkUserEntry = username: {
	options = {
		myFlake.users.${username}.enable = lib.mkEnableOption "Enable user ${username}";
	};
	imports = [ (import (./users + "/${username}.nix") { inherit username; cfg = config.myFlake.users.jac; }) ];
   };
  
   userModules = lib.filterAttrs (k: v: isModule k v) (builtins.readDir ./users);
   usernames = map (entry: lib.strings.removeSuffix ".nix" entry) (builtins.attrNames userModules);
in {
   imports = map (username: (mkUserEntry username)) usernames;
}
