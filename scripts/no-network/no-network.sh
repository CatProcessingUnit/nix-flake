#!/usr/bin/env bash

no-network-ctl start && systemd-run \
	--user \
	--slice="app-nonetwork" \
	--scope \
	"$@"
