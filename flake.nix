{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
	let 
		mkHost = {hostName, desktopEnv, displayProtocol ? "wayland"}: 
			nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					inherit displayProtocol;
				};
				modules = [
					(./. + "/hosts/${hostName}/configuration.nix")
					(./. + "/hosts/${hostName}/hardware-configuration.nix")
					(./. + "/modules/desktop/displayProtocol/${displayProtocol}.nix")
					(./. + "/modules/desktop/${desktopEnv}.nix")
					./modules/default.nix
				];
			};
	in 
	{
		nix.settings = {
			substituters = ["https://hyprland.cachix.org"];
			trusted-substituters = ["https://hyprland.cachix.org"];
			trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
			# Required so non-root users are allowed to use the above substituter/keys.
			# Use @wheel for all sudo users, or list your username explicitly.
			trusted-users = ["root" "@wheel"];
		};
		# home-manager.inputs.nixpkgs.follows = "nixpkgs";
		nixosConfigurations = {
			nix-btw = mkHost {hostName = "nix-btw"; desktopEnv = "KDE"; displayProtocol = "wayland";};
			laptop = mkHost {hostName = "laptop"; desktopEnv = "xfce"; displayProtocol = "x11";};
		};
  	};
}
