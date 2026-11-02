{pkgs, ...}:

let
	script = pkgs.writeShellApplication {
		name = "no-network";
		runtimeInputs = with pkgs; [
			systemd
		];
		text = builtins.readFile ./no-network.sh;
	};
in script
