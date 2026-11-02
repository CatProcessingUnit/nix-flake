{ myLib, lib, pkgs, myFlake, ... }:

{
  imports = myLib.importAllFrom ./modules {};
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
     rnote
     krita
     devenv
     libreoffice-qt
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
  	zsh = {
		enable = true;
	};
	yazi = {
		enable = true;
		enableBashIntegration = true;
		enableZshIntegration = true;
	};
  	prismlauncher = {
		enable = true;
	};
  	kitty = {
		enable = true;
		extraConfig = ''
			shell_integration enabled
		'';
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

		plugins = with pkgs.vimPlugins; [
			nvim-cmp
			cmp-nvim-lsp
			luasnip
			cmp_luasnip
		];		

		initLua = ''
			local cmp = require('cmp')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			local flake_expr = "builtins.getFlake (toString ./.)"

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered()
				},
				mapping = cmp.mapping.preset.insert({
					      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
					      ['<C-f>'] = cmp.mapping.scroll_docs(4),
					      ['<C-Space>'] = cmp.mapping.complete(),
					      ['<C-e>'] = cmp.mapping.abort(),
					      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ 
						name = 'nvim_lsp',
						keyword_length = 1
					},
					{ name = 'luasnip' },
				}),
				performance = {
					max_view_entries = 10, -- limit autocomplete to 10 entries
				},
			})

			vim.lsp.config("nixd", {
				cmd = { "nixd" },
				filetypes = { "nix" },
				root_markers = { "flake.nix", ".git" },
				capabilities = lsp_capabilities,
				settings = {
					nixd = {
						nixpkgs = {
							expr = string.format("import (%s.inputs.nixpkgs) {}", flake_expr),	
						},

						options = {
							nixos = {
								expr = string.format("(%s).nixosConfigurations.%s.options", flake_expr, vim.uv.os_gethostname()),
							}
						},
						formatting = {
							command = { "alejandra" },
						},
					},
				}
			})

			vim.lsp.config("clangd", {
				cmd = { "clangd" },
				root_markers = { ".clangd", "compile_commands.json" },
				filetypes = { "c" },
				capabilities = lsp_capabilities,
			})

			vim.lsp.enable("nixd");
			vim.lsp.enable("clangd");

			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					current_line = true
				},
			})
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
	vscodium = {
		enable = true;
		profiles.default.extensions = with pkgs.vscode-extensions; [
			jnoortheen.nix-ide
			oderwat.indent-rainbow
			vscodevim.vim
			#jdinhlife.gruvbox
		];

	};
	mangohud = {
		enable = true;
		settings = {
			font_size = lib.mkForce 17;
			gpu_stats = true;
			cpu_stats = true;
			fps = true;
			fps_limit = 144;
			no_display = true;
			display_server = true;
			winesync = true;
		};
	};
	btop = {
		enable = true;
	};
	discord = {
		enable = true;
		settings = {
			SKIP_HOST_UPDATE = true;
			IS_MAXIMIZED = true;
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
