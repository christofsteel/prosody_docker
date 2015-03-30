#!/bin/bash

function start_service {
	echo "Service not found"
}

CMDLINE=$@
if [ "$1" == "--noinit" ]; then
	shift
	exec $@
else
	for script in /etc/start.d/*; do
		echo RUNNIN $script
		. $script
		init_service
		start_service
	done
fi
echo "foo"
exec $@

trap 'trap - TERM; kill -s TERM -- -$$' TERM

tail -f /dev/null & wait

exit 0
