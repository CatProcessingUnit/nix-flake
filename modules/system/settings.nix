{config, pkgs, ...}:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}