{pkgs, username, ...}:

{
   users.users.${username} = {
	isNormalUser = true;
	description = "test";
	extraGroups = [ "networkmanager" "wheel" "samba" ];	
	shell = pkgs.zsh;
	hashedPassword = "$6$fAmtURGSCwlOV5kU$euyOlyYgYwmmYRQlYLFIImHLrz2e4oSknxGAXAfsj0fGddhmQN8Pa6W3RU6YSasqZp7yNrfSt6VqILyX/E1CG0";
   };
}
