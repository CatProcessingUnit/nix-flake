{self, inputs, ...}:

let
   lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
   flake = {
	inherit
		self
		inputs
		lib;
   };
   exports = {
	mkHost = (import ./mkHost.nix) flake;
   };
in
exports
