#!/bin/bash

export SCALE_HOME="/SCALE/scale6.2"
export CMDS=${SCALE_HOME}/bin

PID_FILE=$PWD/PID
echo $$ >> $PID_FILE

input="$1"
output="$(basename $input).out"
msgs="$(basename $input).msg"

${CMDS}/scalerte $input $output > $msgs 2>&1 &

PID_SCALE=$!
echo $PID_SCALE >> $PID_FILE
wait $PID_SCALE

# test for "congratualtions" message in output.
if [[ (`grep "=csas[56]" $input |wc -l` == "1" ) || (`grep "=tsunami-3d" $input |wc -l` == "1" ) ]]
    then
    echo "Testing congratulations..."
    if [ `grep "Congratulations" *.out |wc -l` == "0" ]
    then
        echo "Error: no congratulations !"
        exit 1
    else
        echo "OK: Congratulations returned."
    fi
fi

if [ -f $PID_FILE ]; then
	rm -f $PID_FILE
fi

