# reads ./users directory and imports everything from there

{config, lib, ...}:

{
   home-manager.users = 
   	builtins.listToAttrs (
		map
			(e: let
				username = e.name;
			in {
				name = username;
				value = {
					imports = [ (./users + "/${username}/home.nix") ];
					config.home = {
						inherit username;
						homeDirectory = config.users.users.${username}.home;
					};
				};
			})
			(lib.attrsToList (
				builtins.readDir ./users
			))
		);
}
