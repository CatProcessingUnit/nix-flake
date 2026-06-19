# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
	boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "nix-btw"; # Define your hostname.
  
  # Enable networking
  networking = {
	networkmanager = {
		enable = true;
		ensureProfiles = {
			profiles = {
				"Wired connection 1" = {
					connection = {
						type = "ethernet";
						id = "Wired Connection 1";
						interface-name = "eth0";
					};
					ipv4 = {
						method = "manual";
						addresses = "172.28.144.5/20";
						gateway = "172.28.144.1";
					};
				};
			};
		};
	};
  };
  system.stateVersion = "26.05"; # Did you read the comment?
}
