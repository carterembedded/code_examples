#!/bin/bash

function myThread
{
  for ((i=0; i<$1; i++))
  do
    echo "$1"
    sleep $1
  done
}

LIST=(1 2 3 4 5)

for blah in "${LIST[@]}"; do

  myThread $blah &
  sleep 0.2

done

for job in $(jobs -p); do
  wait $job || let "fail+=1"
done

# + echo 540865
# 540865
# + echo 131251
# 131251