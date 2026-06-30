{pkgs, ...}:

{
   options = {
	features.drivers.nvidia.enable = lib.mkEnableOption "enable nvidia drivers";
   };
   config = lib.mkIf config.features.drivers.nvidia.enable {
	hardware.graphics.enable = true;
   	services.xserver.videoDrivers = [ "nvidia" ];
   	hardware.nvidia.open = true;
   };
}
