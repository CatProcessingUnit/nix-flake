{ myLib, lib, pkgs, myFlake, ... }:

{
  imports = myLib.importAllFrom ./modules {};
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.
  
  home.packages = with pkgs; [
     hello
     lolcat
     gh
     rnote
     krita
     devenv
     libreoffice-qt

     # not using programs.discord because
     # discord sometimes destroys the settings.json symlink
     # and it breaks the home-manager activation during rebuild
     discord
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
							expr = string.format("import ((%s).inputs.nixpkgs) {}", flake_expr),
						},

						options = {
							nixos = {
								expr = string.format("(%s).nixosConfigurations.%s.options", flake_expr, vim.uv.os_gethostname()),
							},

							[ "home-manager" ] = {
								expr = string.format("(%s).nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []", flake_expr, vim.uv.os_gethostname()),
							},
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
			
			vim.lsp.config("rust_analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust", "rs" },
				root_markers = { "Cargo.toml", ".git" },
				capabilities = lsp_capabilities,
			})

			vim.lsp.enable("nixd");
			vim.lsp.enable("clangd");
			vim.lsp.enable("rust_analyzer");

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

  home.file = {
  
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
