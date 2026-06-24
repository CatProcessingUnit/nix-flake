{config, pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./locale.nix
    ./sound.nix
    ./settings.nix
    ./networking.nix
    ./packages.nix
  ];
}
