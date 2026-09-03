#!/bin/bash

  BATCHSIZE=7
  componentReportDirectory="./*"
  # How many files are in the directory
  numberOfFiles=$(ls 2>/dev/null -Ub1 -- $componentReportDirectory | wc -l)

  # Gather tracefiles
  for traceFile in $componentReportDirectory; do
    Array+=("$traceFile ")
  done
  let count=0
 
  # Init our out array 
  ArrayOut=()
  # Add one because otherwise it won't work
  for((i=0;i<(($numberOfFiles+1));i++)); do
    # Add files to our array
    ArrayOut+=${Array[$count]}
    let count=$count+1
    let modCount=$count%$BATCHSIZE;

    # If the max batch size is reached, OR the array is at it's end 
    if [[ modCount -eq 0 || i -eq ${#Array[@]} ]]; then
      # Do stuff in here
      echo "Array: $ArrayOut"
      ArrayOut=()
    fi
  done

