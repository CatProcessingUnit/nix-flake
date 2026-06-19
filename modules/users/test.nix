{config, lib, pkgs, ...}:

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
    		shell = pkgs.zsh;
        hashedPassword = "$6$fAmtURGSCwlOV5kU$euyOlyYgYwmmYRQlYLFIImHLrz2e4oSknxGAXAfsj0fGddhmQN8Pa6W3RU6YSasqZp7yNrfSt6VqILyX/E1CG0";
	  };
  }; 
}