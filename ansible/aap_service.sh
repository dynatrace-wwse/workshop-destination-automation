#!/usr/bin/env bash

set -euo pipefail

action="${1:-}"

case "$action" in
	start|stop|restart)
		systemctl --user "$action" postgresql
		systemctl --user "$action" receptor
		systemctl --user "$action" redis-* --all
		systemctl --user "$action" automation-hub* --all
		systemctl --user "$action" automation-controller* --all
		systemctl --user "$action" automation-eda* --all
		systemctl --user "$action" automation-gateway* --all
		;;
	*)
		echo "Valid arguments are: start, stop, or restart."
		;;
esac