{self, inputs, flakePaths, ...}:

let
   lib = inputs.nixpkgs.lib // inputs.home-manager.lib; # merge libs
   myLib = (import ./default.nix) { inherit self inputs flakePaths; }; # so the functions can call each other
   flake = {
	inherit
		self
		inputs
		flakePaths
		myLib
		lib;
   };
   exports = {
	mkHost = (import ./mkHost.nix) flake;
	getAllHosts = (import ./getAllHosts.nix) flake;
	importAllFrom = (import ./importAllFrom.nix) flake;
   };
in
exports
