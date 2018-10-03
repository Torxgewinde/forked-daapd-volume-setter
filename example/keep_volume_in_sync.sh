#!/bin/bash

###############################################################################
# 
# keep the outputs of forked-daapd enabled and keep
# the individual volume of each output in sync to the master volume
#
# without this helper script the volume is different in case of 
# adjustments to the master volume while an output was switched off and back on
#
###############################################################################

HOST="webcam.lan"
OUTPUTS="Audio-1 Audio-2 Computer"

function task() {
	# get current volume
	VOL=$(mpc -h "$HOST" volume | sed -e "s/[^0-9]*\([0-9]*\).*/\1/g")

	echo "Master volume is: $VOL percent"

	for i in $OUTPUTS; do
		#keep these outputs active are reactivate if they were absent in between
		mpc -h "$HOST" enable "$i"
		python output.py "$i" "$VOL"
	done
}

# run the function task more or less as a daemon (detached from the console etc.)
(0<&- 2<&- 1<&- $(cd /tmp && while true; do task; sleep 1; done) &)
exit

###############################################################################
# run it in the current console, no detach
while true; do
	task
	sleep 1
done
