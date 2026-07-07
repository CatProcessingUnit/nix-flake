{pkgs, config, lib, ...}:

{
   options = {
	features.stylix = {
		enable = lib.mkEnableOption "enable stylix";
	};
   };
   config = lib.mkIf (config.features.stylix.enable) {
	stylix = {
		enable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
	};
   };
}
