{moduleInfo, ...}:
{config, lib, pkgs, ...}:

{
	options.myFlake.features.${moduleInfo.name} = {
		enable =
			lib.mkEnableOption "enables OpenSSH server";
	};
	config = lib.mkIf config.myFlake.features.${moduleInfo.name}.enable {	
		services.openssh = {
				enable = true;
				openFirewall = true;
				settings = {
					PasswordAuthentication = true;
					PermitRootLogin = "no";
					AllowUsers = [ "test" ];
					MaxAuthTries = 3;
				};
			};
	};
}
