# wrap packages to use firejail

{...}:
let
   wrapFirejailBinary = {
	pkgs,
	lib ? pkgs.lib,
	myFlake,
	
	package,
	profile ? null,
	extraArgs ? [],

	debug ? false,
  }:
	let
		args = lib.escapeShellArgs (
			extraArgs ++ 
			(lib.optional (profile!=null) "--profile=${profile}")++
			(lib.optional debug "--debug")
		);
		packageName = lib.getName package;
		script = let
			path = "/bin/${packageName}";
		in ''(
			local executable="$out${path}"
			local wrappedExecutable=""$(dirname $executable)/.$(basename $executable)"-wrapped"
			while [ -e "$wrappedExecutable" ]; do
				wrappedExecutable="''${wrappedExecutable}_";
			done
			mv "$executable" "$wrappedExecutable"
			# disable makeShellWrapper executable check
			assertExecutable() {
				:
			}
			makeShellWrapper "/run/wrappers/bin/firejail" "$executable" \
				--add-flags "${args}" \
				--add-flags "$wrappedExecutable" \
				--inherit-argv0
		)'';
	in
		if (!myFlake.features.firejail.enable) then
			builtins.warn "wrapFirejailBinary: not wrapping ${packageName}, firejail is disabled" package
		else
			package.overrideAttrs (old: {
				nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
				buildCommand = old.buildCommand + script;
			});
in wrapFirejailBinary
