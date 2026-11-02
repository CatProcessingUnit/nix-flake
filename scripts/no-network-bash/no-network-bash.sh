#!/run/current-system/sw/bin/bash

# unshare, bwrap, firejail and netns don't work for me in steam for some reason

# creates app-nonetwork.slice and runs the program under it
# and adds a nftable rule to block that slice (cgroup)
# requires sudo, will ask for password every launch

set -x

uid=$(id -u)

# create no-network slice if it doesn't exist
# so 'nft add rule' won't fail
systemctl list-unit-files --user "no-network-keeper.service" \
|| systemd-run \
	--user \
	--slice=app-nonetwork.slice \
	--unit "no-network-keeper" \
	sleep infinity

# check if the rule exists
# if it doesn't, then add it
# allows localhost, because some games require it
command="nft list chain inet filter output | grep 'user.slice/user-${uid}.slice' || nft add rule inet filter output socket cgroupv2 level 5 '\"user.slice/user-${uid}.slice/user@${uid}.service/app.slice/app-nonetwork.slice\"' oifname != 'lo' drop"

run0 /run/current-system/sw/bin/bash -c "$command"
if (( $? == 0 )) then
	systemd-run \
		--user \
		--slice="app-nonetwork" \
		--scope \
		"$@"
fi
