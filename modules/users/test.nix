{config, lib, pkgs, inputs, homeDirectory, ...}:

{
  options = {
    users.test.enable =
      lib.mkEnableOption "test user";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  config = lib.mkIf config.users.test.enable {
	users.users."test" = {
    		isNormalUser = true;
    		description = "test";
    		extraGroups = [ "networkmanager" "wheel" "samba" ];
		packages = with pkgs; [
			home-manager
		];
    		shell = pkgs.zsh;
        	hashedPassword = "$6$fAmtURGSCwlOV5kU$euyOlyYgYwmmYRQlYLFIImHLrz2e4oSknxGAXAfsj0fGddhmQN8Pa6W3RU6YSasqZp7yNrfSt6VqILyX/E1CG0";
	};
	#home-manager.users."test" = homeDirectory + "/test/home.nix";
	#home-manager.users."test" = import (homeDirectory + "/test/home.nix");
   };
}
