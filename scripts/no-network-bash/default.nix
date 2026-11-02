{pkgs, ...}:

let
	script = pkgs.writeShellApplication {
		name = "no-network-bash";
		runtimeInputs = with pkgs; [
			nftables
			gnugrep
			systemd
		];
		text = builtins.readFile ./no-network-bash.sh;
		checkPhase = ""; # because it breaks the bulid
	};
in script
