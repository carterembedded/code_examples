#!/bin/bash

numberOfFiles=$(ls 2>/dev/null -Ub1 -- . | wc -l)

if [[ $numberOfFiles -eq 1 ]]; then

  for((i=0;i<2048;i++)); do
    touch $i
  done

fi


for((i=0;i<2048;i++)); do

  files+="cat $i > "

done

$files
