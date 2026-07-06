{username, pkgs, ...}:

{
   users.users.${username} = {
	isNormalUser = true;
	extraGroups = [ "networkmanager" "wheel" "samba" ];
	shell = pkgs.zsh;
	initialPassword = "";
   };
}
