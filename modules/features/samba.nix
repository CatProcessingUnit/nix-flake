{moduleInfo, ...}:
{config, lib, pkgs, ...}:

{
  options.myFlake.features.${moduleInfo.name} = {
    enable = lib.mkEnableOption "Enable samba server";
  };
  config = lib.mkIf config.myFlake.features.${moduleInfo.name}.enable {
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
