{config, pkgs, lib, ...}:
{
	imports = [
		./overlays
		./ssh.nix
		./samba.nix
	];

	overlays.KDE.enable = lib.mkDefault true;
}
