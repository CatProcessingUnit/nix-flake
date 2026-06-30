{config, pkgs, lib, myLib, ...}:
{
	#imports = [
	#	./overlays
	#	./ssh.nix
	#	./samba.nix
	#	./zram.nix
	#];
	imports = 
		myLib.importAllFrom ./. ++
		myLib.importAllFrom ./overlays ++
		myLib.importAllFrom ./drivers;
}
