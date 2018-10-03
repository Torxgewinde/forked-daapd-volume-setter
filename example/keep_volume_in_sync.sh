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

HOST="forked-daapd.server.lan"
OUTPUTS="Audio-1 Audio-2 Computer"

function task() {
	# get current volume
	VOL=$(mpc -h "$HOST" volume | sed -e "s/[^0-9]*\([0-9]*\).*/\1/g")

	echo "Master volume is: $VOL percent"
	
	for i in $OUTPUTS; do
		# ensure our outputs are enabled al the time
		mpc -h "$HOST" enable "$i" > /dev/null

		THIS_INFO=$(python output.py "$i")
		THIS_VOL=$(echo "$THIS_INFO" | grep outputvolume | sed -e "s/[^0-9]*\([0-9]*\)/\1/g")
		THIS_ENABLE=$(echo "$THIS_INFO" | grep outputenabled | sed -e "s/[^0-9]*\([0-9]*\)/\1/g")

		if [ "$THIS_ENABLE" != "1" ]; then
			echo "output not be enabled, seems to be offline. Skipping..."
			continue
		fi

		if [ "$VOL" != "$THIS_VOL" ]; then
			python output.py "$i" "$VOL"
		fi
	done

	sleep 5
}

# run the function task more or less as a daemon (detached from the console etc.)
# (0<&- 2<&- 1<&- $(cd /tmp && while true; do task; done) &)
# exit

###############################################################################
# run it in the current console, no detach
while true; do
	task
done
