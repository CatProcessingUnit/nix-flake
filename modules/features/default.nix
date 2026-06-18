{config, pkgs, lib, ...}:
{
	imports = [
		./features/ssh.nix
	];

	features.ssh.enable = lib.mkDefault false;
}
