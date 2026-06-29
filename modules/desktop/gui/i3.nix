{config, pkgs, lib, ...}:

{
   config = lib.mkIf (config.desktop.env == "i3") {
	assertions = [
		{
			assertion = (config.desktop.displayProtocol == "x11");
			message = "only x11 is supported on i3";
		}
	];
	services = {
		xserver = {
			windowManager.i3 = {
				enable = true;
				extraPackages = with pkgs; [
					dmenu #application launcher
					i3status # status bar
					i3lock
				];
			};
		};
		displayManager.defaultSession = "none+i3";
	};
   };
}
