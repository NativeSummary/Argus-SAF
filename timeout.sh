#!/bin/bash

TIMEOUT=${JNSAF_TIMEOUT:-0}
echo JNSAF_TIMEOUT: $TIMEOUT

/usr/bin/time -v /usr/bin/timeout --kill-after=60s $TIMEOUT bash /root/Argus-SAF/runTool.sh "$@" 2> >(tee /root/apps/docker_stderr.txt >&2)

touch /root/apps/JNSAF_FINISHED
