{moduleInfo, ...}:
{config, pkgs, lib, ...}:

let
	cfg = config.myFlake.session;
in {
   config = lib.mkIf (cfg.desktopEnvironment == "${moduleInfo.name}") (lib.mkMerge [
   	{
		services.xserver.desktopManager.lxqt.enable = true;
		xdg.portal.lxqt = {
			enable = true;
		};
	}
	(lib.mkIf (cfg.displayProtocol == "wayland") {
		assertions = [
			{
				assertion = (cfg.windowManager != null);
				message = "LXQt on wayland requires a wayland compositor (set with session.windowManager)";
			}
		];
		environment.systemPackages = with pkgs; [
				lxqt.lxqt-wayland-session
				lxqt.lxqt-config
		];
		services.displayManager.sessionPackages = with pkgs.lxqt; [
			lxqt-wayland-session
		];
		home-manager.sharedModules = [
			# tells lxqt to use the selected window manager
			{
				xdg.configFile."lxqt/session.conf".text = lib.generators.toINI {} {
					General = {
						__userfile__ = "true";
						compositor = "${cfg.windowManager}";
					};
				};
			}
		];
	})
   ]);
}
