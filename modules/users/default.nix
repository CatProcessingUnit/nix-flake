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
	options.myFlake.users.${username} = {
		enable = lib.mkEnableOption "Enable user ${username}";
		isAdmin = lib.mkEnableOption "Add ${username} to wheel group";
	};
	imports = [ 
		(let
			data = (import (./users + "/${username}.nix") { inherit pkgs; });
			cfg = config.myFlake.users.${username};
		in {
			config.users.users.${username} = lib.mkIf (cfg.enable)
				(if builtins.elem "wheel" data.extraGroups then
					builtins.throw "do not add user ${username} to wheel group manually, use myFlake.users.${username}.isAdmin instead"
				else (data // 
					{
						extraGroups = if (cfg.isAdmin) then 
								([ "wheel" ] ++ data.extraGroups) 
							else 
								data.extraGroups;
					})
				);
			})
	];
   };
  
   userModules = lib.filterAttrs (k: v: isModule k v) (builtins.readDir ./users);
   usernames = map (entry: lib.strings.removeSuffix ".nix" entry) (builtins.attrNames userModules);
in {
   imports = map (username: (mkUserEntry username)) usernames;

   assertions = let
	adminCount = lib.lists.foldr (user: acc: if (config.myFlake.users.${user}.isAdmin) then acc + 1 else acc) 0 usernames;
   in [{
	assertion = adminCount >= 1;
	message = "atleast 1 admin is required (set with myFlake.users.username.isAdmin)";
   }];
}
