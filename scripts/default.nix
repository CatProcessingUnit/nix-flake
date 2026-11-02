{lib, pkgs, ...}:

let
	files = lib.filterAttrs (k: v: k != "default.nix" && v == "regular") (builtins.readDir ./.);
in {
	security.wrappers.no-network-ctl = let
		no-network-ctl = (import ./no-network-ctl { inherit pkgs; });
	in {
		source = "${no-network-ctl}/bin/no-network-ctl";
		capabilities = "cap_net_admin+ep";
		owner = "root";
		group = "root";
	};
	environment.systemPackages = with pkgs; [
		(import ./no-network { inherit pkgs; })
		(import ./prism-sandbox { inherit pkgs; })
	];
}
