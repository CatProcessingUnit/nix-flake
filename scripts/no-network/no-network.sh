#!/usr/bin/env bash

# add nftables rules with no-network-ctl start
systemd-run \
	--user \
	--slice="app-nonetwork" \
	--scope \
	"$@"
