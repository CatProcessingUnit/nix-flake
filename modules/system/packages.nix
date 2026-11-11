{config, pkgs, ...}:

{
   environment.systemPackages = with pkgs; [
	vim
	iotop
	lsof
	fatrace
   ];

   programs = {
	zsh.enable = true;
   };
}
