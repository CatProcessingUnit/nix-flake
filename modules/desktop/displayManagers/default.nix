{config, pkgs, myLib, ...}:

{
   #imports = [
#	./sddm.nix
#	./lightDM.nix
   #];
   imports = myLib.importAllFrom ./.;
}
