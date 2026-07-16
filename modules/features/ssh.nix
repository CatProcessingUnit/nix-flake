{config, lib, pkgs, ...}:

{
	options.myFlake.features.ssh = {
		enable =
			lib.mkEnableOption "enables OpenSSH server";
	};
	config = lib.mkIf config.myFlake.features.ssh.enable {	
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
