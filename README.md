# forked-daapd-volume-setter
Set the volume of several airplay speakers individually

Forked-Daapd supports output to several shairplay-sync receivers. The regular version permits setting the volume for all speakers at once, the iOS "Remote App" can set the volume indivdually. To access this from the command line I needed a little helper tool.

#Usage

  python /home/tom/bin/output.py "Audio-1" 60
  
  Where "Audio-1" is the name of the speaker and 60 is the desired volume.
