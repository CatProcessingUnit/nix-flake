{config, pkgs, lib, myLib, ...}:

{
   #imports = [
#	./wayland.nix
#	./x11.nix
   #];
   imports = myLib.importAllFrom ./.;
}
