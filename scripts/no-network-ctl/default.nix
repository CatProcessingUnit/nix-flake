{pkgs, ...}:

pkgs.stdenv.mkDerivation {
	pname = "no-network-ctl";
	version = "0.1";
	src = ./.;

	nativeBuildInputs = [
		pkgs.clang
	];

	buildInputs = with pkgs; [
		libcap
		nftables
		json_c
	];

	buildPhase = ''
		clang no_network.c -o no-network-ctl \
			-lcap \
			-lnftables \
			-ljson-c
	'';

	installPhase = ''
		mkdir -p $out/bin
		install -m755 no-network-ctl $out/bin/no-network-ctl
	'';

}
