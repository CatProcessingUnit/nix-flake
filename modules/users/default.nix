{config, lib, pkgs, ...}:

{
  imports = [
    ./test.nix
  ];

  users.test.enable = lib.mkDefault true;
}
