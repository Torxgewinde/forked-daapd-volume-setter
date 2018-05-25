import sys
from mpd import MPDClient

client = MPDClient()
client.connect('localhost', 6600)

def isCorrectOutput(s):
    for key, val in s.items():
        if key == "outputname":
            if val == sys.argv[1]:
                return True
    return False

results = filter(isCorrectOutput, client.outputs())

# set volume
if len(sys.argv) == 3:
    for aResult in results:
        for key, val in aResult.items():
            #print key + ': ' + val
            if key == "outputid":
                client.outputvolume(val, int(sys.argv[2]))

# print volume
for aResult in results:
    for key, val in aResult.items():
        print key + ': ' + val
    print '---'

client.disconnect()
