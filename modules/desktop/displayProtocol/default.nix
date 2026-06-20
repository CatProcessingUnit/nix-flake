{config, pkgs, lib, ...}:

{
   imports = [
	./wayland.nix
	./x11.nix
   ];
}
