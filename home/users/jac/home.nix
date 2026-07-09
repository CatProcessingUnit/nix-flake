{ lib, pkgs, ... }:

{ 
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  #home.file = {
	#".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
  #};
  #xdg.configFile = {
#	"nvim" = {
#		source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
#		#recursive = true;
#	};
#  };
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
     hello
     lolcat
     gh
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  xdg.terminal-exec = {
	enable = true;
	settings = {
		default = [
			"kitty.desktop"
		];
	};
  };
  programs = {
  	kitty = {
		enable = true;
		#themeFile = "Campbell";
		#theme = "Gruvbox Material Dark Medium";
		themeFile = "GruvboxMaterialDarkMedium";
	};
	firefox = {
		enable = true;
	};
	fastfetch = {
		enable = true;
	};
	neovim = {
		enable = true;
		defaultEditor = true;

		viAlias = true;
		vimAlias = true;
		
		extraPackages = with pkgs; [
			nixd
		];

		plugins = with pkgs.vimPlugins; [];

		initLua = ''
			local flake_expr = "builtins.getFlake (toString ./.)"	

			vim.lsp.config("nixd", {
				cmd = { "nixd" },
				filetypes = { "nix" },
				root_markers = { "flake.nix", ".git" },
				settings = {
					nixd = {
						nixpkgs = {
							expr = string.format("import (%s.inputs.nixpkgs) {}", flake_expr),	
						},
						formatting = {
							command = { "alejandra" },
						},
					},
				},
			})
			vim.lsp.enable("nixd");
		'';

	};
	git = {
		enable = true;
		settings = {
			user = {
				name = "CatProcessingUnit";
				email = "39676061+CatProcessingUnit@users.noreply.github.com";
			};
		};
	};
	vscode = {
		enable = true;
		profiles.default.extensions = with pkgs.vscode-extensions; [
			jnoortheen.nix-ide
			oderwat.indent-rainbow
			vscodevim.vim
			#jdinhlife.gruvbox
		];

		profiles.default.userSettings = {
			"telemetry.telemtryLevel" = "off";
			
			#"workbench.colorTheme" = "Gruvbox Dark Medium";
		};
	};
	mangohud = {
		enable = true;
		settings = {	
			gpu_stats = true;
			cpu_stats = true;
			fps = true;
		};
	};
  };
  stylix = {
	targets = {
		mangohud = {
			opacity.override = {
				popups = 0;
			};
		};
	};
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/test/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
