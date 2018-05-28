#!/bin/bash

# ######################################################################################
#
# This scripts sets all outputs to the same volume like the master volume
# Written by Tom Stöveken, 2018
# 
# Tested on Ubuntu Bionic
# MPC is version 0.29-1
# forked-daapd is version 26.0 (compiled from sources)
#
########################################################################################

HOST=musicbox.fritz.box

# read the output IDs to a space separated string
IDs="$(mpc -h $HOST outputs | sed -e "s/Output \([0-9]*\).*/\1 /g" | tr -d '\n' && echo)"

#read current master volume
VOL="$(mpc -h $HOST volume | sed -e "s/[Vv]olume: \([0-9]*\).*/\1/g")"

#set all the outputs at once
for I in $IDs; do
  IminusOne=$(($I-1))
  mpc -h $HOST sendmessage outputvolume "$IminusOne:$VOL"
done


