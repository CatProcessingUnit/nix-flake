{moduleInfo, ...}:
{pkgs, config, lib, ...}:

let
	cfg = config.myFlake.features.${moduleInfo.name};
in {
   options.myFlake.features.${moduleInfo.name} = {
	enable = lib.mkEnableOption "enable gaming";
	steam = {
		isolateHome = lib.mkOption {
			type = lib.types.bool;
			default = true;
			description = "mounts fake home inside steam's bwrap sandbox";
		};
	};
   };
   config = lib.mkIf cfg.enable {
	programs = {
		steam = {
			enable = true;
			package = let
					steamHomeName = "steam-home";
				in lib.mkIf (cfg.steam.isolateHome)
					(pkgs.steam.override {
						extraBwrapArgs = [
							"--bind $HOME/${steamHomeName} $HOME"
							"--bind $HOME/.local/share/Steam $HOME/.local/share/Steam"
							"--bind $HOME/.steam $HOME/.steam"

							"--ro-bind-try $HOME/.config/fontconfig $HOME/.config/fontconfig"
							"--ro-bind-try $HOME/.config/MangoHud $HOME/.config/MangoHud"
						];
					});

			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			extraCompatPackages = with pkgs; [
				proton-ge-bin
			];
		};
		gamescope = {
			enable = true;
			capSysNice = true;
		};
		gamemode = {
			enable = true;
		};
	};
	environment.systemPackages = with pkgs; [
		protonup-qt
	];
	# for PROTON_ENABLE_NTSYNC
	boot.kernelModules = [
		"ntsync"
	];
   };
}
