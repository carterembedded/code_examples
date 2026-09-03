#!/bin/bash

# removeOldTars
# Author: Harrison James Marcks

source /home/marcks/scripts/commonCoverageFunctions.sh

# Just deletes old tars in the /home/tester.nds/coverage directory

TARORIGINDIR="/mnt/fs01.brs/home/tester.nds/coverage/"
STARTTIME=$(date +%s)

##############################################################################
# helpFunction - Displays help text to the user; documenting the switches
# Parameters: $1= the code to exit with
##############################################################################
function helpFunction
{
  local exitCode="$1"
  printf "usage: postJobMerge.py [-h] [-t TRACEFILEDIRROOT] [-w WORKSPACE]\n"
  printf "                       [-v MAINRELEASEVERSION] [-f FULLVERSION]\n\n"

  printf "Coverage tar remover\n\n"

  printf "optional arguments:\n"
  printf "  -v CINUMBER           The CI Number as understood in RTEST\n"

  exit $exitCode
}

if [[ "$1" == "--help" ]] || [[ $1 == "-h" ]]; then
  helpFunction 0
fi

while getopts "t:w:v:f:h" OPTIONS; do
  case "$OPTIONS" in
    v)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      CINUMBER="$OPTARG"
      ;;
    h)
      helpFunction 0
      ;;
    \?)
      echo "INVALID Option"
      echo "Type incrementalGeneration.sh -h for help!"
      exit 1
      ;;
    :)
      echo "No argument supplied!"
      echo "Type incrementalGeneration.sh -h pr --help for help!"
      exit 1
      ;;
  esac
done

function prepare
{
  # We need to extract the CI number
  # One-NDS-SONAR-19.0.0-CI253
  CINUMBER="$(echo $CINUMBER | cut -d'-' -f5)"

}

function gatherTars
{
  local tarsToRemove=""

  for tars in "$TARORIGINDIR"/*; do
    if [[ ! "$tars" =~ $CINUMBER ]] && [[ -f "$tars" ]] ; then
      tarsToRemove="$tarsToRemove $tars"
    fi
  done
  
  rm -f $tarsToRemove
}

gatherTars
