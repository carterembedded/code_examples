#!/bin/bash

## COMMON VARIABLES/CONSTANTS ##

# This is the basic component list. We'll generate the JOB name in a seperate
# function
# Component folder name
COMPONENTLIST=("gen" "asn1" "ddb" "sdf")
# Componet Job name
PATHLIST=("GEN" "ASN-1" "DDB" "DS")
# Direct Path to the LCOV script we'll be using
__LCOV="/mnt/fs01.brs/home/marcks/bin/scripts/lcov-1.13-1.noarch/usr/bin/lcov"
#Path to LCOVtoCobertura script
__LCOVTOCOBERTURA="/mnt/fs01.brs/home/marcks/bin/scripts/lcov_cobertura/lcov_cobertura.py"
# The time in seconds that the script started
__STARTTIME=$(date +%s)
# The NDS main release version
# Get this from a command line argument, -v
__MAINRELEASEVERSION=""

###############################################################################
# getJobName - returns the total name f the hudson job. For building the
#              directorypath up
# Parameters: $1 = component, the name of the component to get the job name for
###############################################################################
function getJobName()
{
  local component="$1"
  local jobName
  case "$component" in
    "gen")
      jobName="${PATHLIST[0]}"_"$MAINRELEASEVERSION"_SONAR
      ;;
    "asn1")
      jobName="${PATHLIST[1]}"_"$MAINRELEASEVERSION"_SONAR
      ;;
    "ddb")
      jobName="${PATHLIST[2]}"_"$MAINRELEASEVERSION"_SONAR
      ;;
    "sdf")
      jobName="${PATHLIST[3]}"_"$MAINRELEASEVERSION"_SONAR
      ;;
    \?) # Default case
      ;;
  esac

  echo "$jobName"
}

###############################################################################
# getTimeElapsed - prints the elapsed time between two points
# Parameters: $1 = STARTTIME, the time to begin timing from
###############################################################################
function getTimeElapsed()
{
  local currentTime=$(date +%s)
  local startTime=__STARTTIME
  local elapsedTime="$currentTime"-"$startTime"

  local days=$((elapsedTime/60/60/24))
  local hours=$((elapsedTime/60/60%24))
  local minutes=$((elapsedTime/60%60))
  local seconds=$((elapsedTime%60))
  printf "Elapsed: "
  printf '%01d days and %01d:%01d:%01d \n' "$days" "$hours" "$minutes" "$seconds"
}

##############################################################################
# OPTARGCheck - Checks whether the argument for an option has been supplied
#               $1 = The information
#               $2 = The switch the information is attached to
#               $3 = Is the option required (true for yes, false nor not)
##############################################################################
function OPTARGCheck()
{
  local optionToCheck="$1"
  local switch="$2"
  local required="$3"

  if [[ -z "$optionToCheck" ]]; then
     printf "Missing value for $switch\n"
     helpFunction 1
  fi

}

#############################################################################
############################  THIS ISN'T USED   #############################
########### It also doesn't work. Kept for inspiration/posterity.
# foldercrawlerAndProcessLauncher - This function will navigate the source tree a maximum of 2 folders deep
#                                  and spawn an lcov process in each folder containg source files
############################  THIS ISN'T USED   #############################
#############################################################################
function foldercrawlerAndProcessLauncher
{
  local componentBuildRoot="$1"
  local component="$3"

  local currentDir="$toplevelDir"  
  local currentBaseName=$(basename $currentDir)

  for files in $currentDir/*; do
    # If it's a directory
    if [[ -d $files ]]; then
      # If test is not in the name
      if [[ ! $files =~ *test* ]]; then
        local $oneDownDir=$files
        filesInDir=($(find $oneDownDir -type f \( -name "*.c" -or -name "*.cpp" \))) # Find files with a .c or .cpp extension
        directoriesInDir=($(find $oneDownDir -type d )) # Find directories in our Dir

        # If this folder cotnains source files, generate coverage
        if [[ ${#filesInDir[@]} -gt 0 ]]; then
          # Files with c or cpp extensions are present
          local oneDirBaseName=$(basename $files)
          local LCOVREPORTFILE="$component.$TASKNUMBER.$dirsTwoDown.$TRACEFILECOUNTER.lcov"
          ($LCOVSCRIPTS --capture --directory $oneDownDir --output-file $componentReportDirectory/$LCOVREPORTFILE --gcov-tool /usr/bin/gcov\
          | sed 's/^/    # /') &
        fi

        # If a directory is present "delve" into it
        for dirsTwoDown in  ${directoriesInDir[@]}; do
          if [[ ! $dirsTwoDown =~ *test* ]]; then
            if [[ -d $dirsTwoDown ]]; then
            # Files with c or cpp extensions are present
            local oneDirBaseName=$(basename $files)
            local LCOVREPORTFILE="$component.$TASKNUMBER.$oneDirBaseName.$TRACEFILECOUNTER.lcov"
            ($LCOVSCRIPTS --capture --directory $oneDownDir --output-file $componentReportDirectory/$LCOVREPORTFILE --gcov-tool /usr/bin/gcov\
            | sed 's/^/    # /') &
            fi
          fi
        done

      fi
    fi
  done
}