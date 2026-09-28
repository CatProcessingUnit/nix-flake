{lib, pkgs, ...}:

let
	files = lib.filterAttrs (k: v: k != "default.nix" && v == "regular") (builtins.readDir ./.);
in {
	environment.systemPackages = with pkgs; [
		(import ./no-network { inherit pkgs; })
		(import ./prism-sandbox { inherit pkgs; })
	];
}
