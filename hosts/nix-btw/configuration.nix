# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let
  a = 1;
in
{
  # config.features.ssh.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "nix-btw"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
	pipewire = {
	    enable = true;
	    alsa.enable = true;
	    alsa.support32Bit = true;
	    pulse.enable = true;
	    # If you want to use JACK applications, uncomment this
	    #jack.enable = true;

	    # use the example session manager (no others are packaged yet so this is enabled by default,
	    # no need to redefine it in your config for now)
	    #media-session.enable = true;
	};
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
	"test" = {
    		isNormalUser = true;
    		description = "test";
    		extraGroups = [ "networkmanager" "wheel" ];
    		packages = with pkgs; [
      			#  kdePackages.kate
    			#  thunderbird
    		];
    		shell = pkgs.zsh;
	};
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05"; # Did you read the comment?

}
