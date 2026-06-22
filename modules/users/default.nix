{config, lib, pkgs, ...}:

{
  imports = [
    ./test
  ];

  users.test.enable = lib.mkDefault true;
}
