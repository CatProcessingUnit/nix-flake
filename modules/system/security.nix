{pkgs, ...}:

{
   environment.systemPackages = with pkgs; [
	bubblewrap
   ];
   security = {
	sudo = {
		extraConfig = # sh
			''
				Defaults pwfeedback # typed passwords show as asterisks
			'';
	};
	polkit = {
		enable = true;
	};
   };
}
