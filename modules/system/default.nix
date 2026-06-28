{config, pkgs, myLib, ...}:

{
  #imports = [
  #  ./boot.nix
  #  ./locale.nix
  #  ./sound.nix
  #  ./settings.nix
  #  ./networking.nix
  #  ./packages.nix
  #];
  imports = myLib.importAllFrom ./.;
}
