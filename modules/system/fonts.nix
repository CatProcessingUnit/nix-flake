{pkgs, lib, ...}:

{
	fonts.packages = with pkgs; [
		nerd-fonts.symbols-only
	];
}
