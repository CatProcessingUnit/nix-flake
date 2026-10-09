{moduleInfo, ...}:
{pkgs, lib, config, ...}:

let
	cfg = config.myFlake.features.${moduleInfo.name};
in {
	options.myFlake.features.${moduleInfo.name} = {
		enable = lib.mkEnableOption "enable virtualisation";
		bridge = {
			enable = lib.mkEnableOption "enable bridge";
			allowedBridges = lib.mkOption {
				default = [];
				type = with lib.types; (listOf str);
				description = "bridge interfaces";
			};
		};
	};

	config = lib.mkIf cfg.enable {
		assertions = [
			{
				assertion = cfg.bridge.enable && (builtins.length cfg.bridge.allowedBridges) >= 1;
				message = "virtualisation.allowedBridges is empty";
			}
		];
		# create the network bridge, if enabled
		networking = lib.mkIf cfg.bridge.enable {
			bridges.br0.interfaces = cfg.bridge.allowedBridges;
			interfaces.br0.useDHCP = true;
		};
		virtualisation = {
			libvirtd = {
				enable = true;
				# TPM emulation
				qemu = {
					swtpm.enable = true;
				};
				allowedBridges = lib.mkIf cfg.bridge.enable [ "br0" ];
			};
		};
		programs = {
			virt-manager.enable = true;
		};
		environment.systemPackages = with pkgs; [
			dnsmasq # VM networking
		];
	};
}
