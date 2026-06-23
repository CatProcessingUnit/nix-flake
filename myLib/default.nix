{self, inputs, lib, flakeRoot, ...}:

let
   flake = {
	inherit
		self
		inputs
		lib
		flakeRoot;
   };
in
{
   mkHost = import ./mkHost.nix flake;
}
