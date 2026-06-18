{config, lib, pkgs, ...}:

{
	options = {
		features.ssh.enable =
			lib.mkEnableOption "enables OpenSSH server";
	};
	config = lib.mkIf config.features.ssh.enable {	
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
