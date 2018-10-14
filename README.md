# forked-daapd-volume-setter
Set the volume of several airplay speakers individually

Forked-daapd supports output to several shairplay speakers. To set the volume of each speaker from the command-line this helper tool is useful.

Install
-------
You need to install `python-mpd2` first: 

    pip install python-mpd2

Usage
-----
The speakers name is `Audio-1` and the desired volume is 60:

    python /home/tom/bin/output.py "Audio-1" 60
