{config, pkgs, lib, ...}:
{
	imports = [
		./ssh.nix
		./samba.nix
	];

	features.ssh.enable = lib.mkDefault false;
	features.samba.enable = lib.mkDefault false;
}
