{username, cfg, ...}:
{pkgs, lib, ...}:

{
   config = lib.mkIf (cfg.enable) {
	   users.users.${username} = {
		isNormalUser = true;
		extraGroups = [ "networkmanager" "wheel" "samba" "gamemode" ];
		shell = pkgs.zsh;
		initialPassword = "";
	   };
   };
}
