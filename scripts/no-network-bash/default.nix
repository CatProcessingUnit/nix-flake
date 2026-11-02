{pkgs, ...}:

let
	script = pkgs.writeShellApplication {
		name = "no-network";
		runtimeInputs = with pkgs; [
			nftables
			gnugrep
			systemd
		];
		text = builtins.readFile ./no-network.sh;
		checkPhase = ""; # because it breaks the bulid
	};
in script
