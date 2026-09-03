#!/bin/bash

  componentReportDirectory="./*"

  numberOfFiles=$(ls 2>/dev/null -Ub1 -- ./* | wc -l)
  let numberOfBatches=$numberOfFiles/3
  let numBatchMod=$numberOfFiles%3
  if [[ $numBatchMod -gt 0 ]]; then
    let numberOfBatches+=1
  fi
  echo "numbatch: $numberOfBatches"

  for traceFile in $componentReportDirectory; do
    Array+=("$traceFile ")
  done

  thing=${Array[@]}
  echo $thing  
  echo "Files Gathered: ${#Array[@]}"

  let count=0
  
  ArrayOut=()
  for((i=0;i<(($numberOfFiles+1));i++)); do
    ArrayOut+=${Array[$count]}
    let count=$count+1    
    let modCount=$count%3;

    if [[ modCount -eq 0 || i -eq ${#Array[@]} ]]; then
      blah=${ArrayOut[@]}
      echo "break: $i"
      ArrayOut=()
      echo $blah
    fi
  done

