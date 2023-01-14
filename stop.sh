# !/bin/bash

echo "killing the emulator.."

pids=`ps -A | grep "flow emulator" | grep -v "grep" | awk '{print $1}'`

for pid in $pids
do
    kill -9 $pid
done
 