{config, lib, pkgs, ...}:

{
  options = {
    features.samba.enable = lib.mkEnableOption "Enable samba server";
  };
  config = lib.mkIf config.features.samba.enable {
    environment.systemPackages = with pkgs; [
	gvfs
    ];
    services.samba = {
      enable = true;
      usershares.enable = true;
      openFirewall = true;
      package = pkgs.samba4Full;
    };

    # windows discovery
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
