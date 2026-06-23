{config, pkgs, ...}:

{
   environment.systemPackages = with pkgs; [
	vim
	#home-manager
   ];

   programs = {
	zsh.enable = true;
   };
}
