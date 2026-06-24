{config, pkgs, lib, ...}:
{
	imports = [
		./overlays
		./ssh.nix
		./samba.nix
		./zram.nix
	];
}
