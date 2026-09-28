{pkgs, ...}:

let
	script = pkgs.writeShellApplication {
		name = "prism-sandbox";
		runtimeInputs = with pkgs; [];
		text = builtins.readFile ./prism-sandbox.sh;
	};
in script
