{...}: {
	systemd.user.services.no-network-ctl = {
		Unit = {
			Description = "launches no-network-ctl start";
		};

		Service = {
			Type = "oneshot";
			ExecStart = "/run/wrappers/bin/no-network-ctl start";
		};

		Install = {
			WantedBy = [ "default.target" ];
		};
	};
}
