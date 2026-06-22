{config, pkgs, ...}:
{
	nixpkgs.config.allowUnfree = true;

	programs = {
		git = {
			enable = true;
		};
		firefox = {
			enable = true;
		};
		zsh = {
			enable = true;
		};
		neovim = {
			enable = true;
		};
  	};

	environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		#  wget
		kitty
		fastfetch
		(vscode-with-extensions.override {
			vscodeExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
				{
					name = "Vim";
					publisher = "vscodevim";
					version = "1.32.4";
					sha256 = "+hyJZinWsa6U+s0fdrx2wUi6tOV3FNKf8O1qMMZEdkQ=";
				}
			];
		})	
	];	
}
