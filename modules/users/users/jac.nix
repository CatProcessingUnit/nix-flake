{pkgs, ...}:

let
	data = {
		isNormalUser = true;
		extraGroups = [ "networkmanager" "samba" "gamemode" ];
		shell = pkgs.zsh;
		initialPassword = "";
	};
in data
