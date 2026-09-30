{pkgs, ...}:

let
	script = pkgs.writeShellApplication {
		name = "prism-sandbox";
		runtimeInputs = with pkgs; [
			bubblewrap
		];
		text = builtins.readFile ./prism-sandbox.sh;
	};
in script
