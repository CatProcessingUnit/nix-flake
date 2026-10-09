{moduleInfo, ...}:
{pkgs, lib, config, ...}:

let
	cfg = config.myFlake.features.${moduleInfo.name};
in {
	options.myFlake.features.${moduleInfo.name} = {
		enable = lib.mkEnableOption "enable virtualisation";
	};

	config = lib.mkIf cfg.enable {
		virtualisation = {
			libvirtd = {
				enable = true;
				# TPM emulation
				qemu = {
					swtpm.enable = true;
				};

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
