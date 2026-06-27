{self, inputs, flakePaths, ...}:

let
   lib = inputs.nixpkgs.lib // inputs.home-manager.lib; # merge libs
   myLib = (import ./default.nix) { inherit self inputs; }; # so the functions can call each other
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
   };
in
exports
