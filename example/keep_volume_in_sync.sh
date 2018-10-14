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
NETWORK_OUTPUTS="Audio-1 Audio-2"
LOCAL_OUTPUTS="Computer"

function set_volume() {
        if [ $# -ne 1 ]; then
                echo "Call this function with the output as parameter"
                return 1
        fi

         # ensure our outputs are enabled al the time
        mpc -h "$HOST" enable "$i" > /dev/null

        THIS_INFO=$(python /home/pi/bin/output.py "$i")
        THIS_VOL=$(echo "$THIS_INFO" | grep outputvolume | sed -e "s/[^0-9]*\([0-9]*\)/\1/g")
        THIS_ENABLE=$(echo "$THIS_INFO" | grep outputenabled | sed -e "s/[^0-9]*\([0-9]*\)/\1/g")

        if [ "$THIS_ENABLE" != "1" ]; then
                echo "output not be enabled. Skipping..."
                continue
        fi

        if [ "$VOL" != "$THIS_VOL" ]; then
                python /home/pi/bin/output.py "$i" "$VOL"
        fi
}

function task() {
        # get current volume
        VOL=$(mpc -h "$HOST" volume | sed -e "s/[^0-9]*\([0-9]*\).*/\1/g")

        echo "Master volume is: $VOL percent"

        # iterate over all networked outputs
        for i in $NETWORK_OUTPUTS; do
                #is the audio receiver online? Skip this audio-receiver if it is not responding to ping
                ping -c 1 "$i" > /dev/null
                if [ $? -ne 0 ]; then
                        echo "output is not responding to ping, Skipping..."
                        continue
                fi

                set_volume "$i"
        done

        #iterate over all local outputs
        for i in $LOCAL_OUTPUTS; do
                set_volume "$i"
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
