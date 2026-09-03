#!/bin/bash

# Contains a functions and constants related to both the incremental generation and postJobMerge Scripts
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
source $scriptDir/commonCoverageFunctions.sh

# postJobMerge.sh
# Author: Harrison James 'Harry' Marcks

# This script will manage the post job script merge.
# It will merge all available LCOV tracefiles into a single ".total" file,
# then convert it to cobertura format and move into place

# Go into the Incremental Generation Job's workspace
# Combine each components tracefiles
  # This can be done in parallel
# Convert each '.total' to cobertura format
  # Done in parallel, the file will be "${component}.lcov.total.xml"
# Move a copy of the '.xml' into the ${WORKSPACE}/BuildNumber
  # Parallel
# Rename and move each '.xml' into their respective buildSrc
  # The new name will be 'COVERAGE-LCOV-REPORT.xml'

# This is the component root of where we the tracefiles are stored
# THIS IS THIS WORKSPACE it's where the TRACEFILES ARE ALREADY STORED
# Get this from a command line argument, -t
TRACEFILEDIRROOT=""
# The NDS main release version
# Get this from a command line argument, -v
MAINRELEASEVERSION="$__MAINRELEASEVERSION"
# The Full NDS version this ran against
# i.e. One-NDS-SONAR-19.0.0-CI253
# Get this form the command line, -f
FULLVERSION=""
# This is our current workspace
# Get this form the command line, -w
WORKSPACE=""
# This is where the final reports will be stored in their ".total.lcov" form
# derived in initScript()
FINALREPORTDIRROOT=""
# Increase/decrese this to change the limit for loops.
WATCHDOGLIMIT=2000
# Defines the batch size for batch merging
BATCHSIZE=25

# The paths to the LCOV scripts. Variables gotten from sourced file
# NB Trailing "safety" spaces
LCOVSCRIPTS="$__LCOV "
LCOVTOCOBERTURASCRIPT="$__LCOVTOCOBERTURA "

##############################################################################
# helpFunction - Displays help text to the user; documenting the switches
# Parameters: $1= the code to exit with
##############################################################################
function helpFunction()
{
  local exitCode="$1"
  printf "usage: postJobMerge.py [-h] [-t TRACEFILEDIRROOT] [-w WORKSPACE]\n"
  printf "                       [-v MAINRELEASEVERSION] [-f FULLVERSION]\n\n"

  printf "LCOV tracefile merger\n\n"

  printf "optional arguments:\n"
  printf "  -h, --help            show this help message and exit\n"
  printf "  -t TRACEFILEDIRROOT   The absolute path to the nominated work space.This is\n"
  printf "                        where the tracefiles are already stored\n"
  printf "  -w WORKSPACE          The path to this jobs workspace\n"
  printf "  -v MAINRELEASEVERSION\n"
  printf "                        The current Main Version of NDS. i.e. 16/16.5/17/19\n"
  printf "                        This is used to help build the paths\n"
  printf "  -f FULLVERSION        The full build version. i.e. One-NDS-\n"
  printf "                        SONAR-19.0.0-CI253\n\n"
  printf "  -l BUILDLABEL         The label given (usually just 'label'). Only use if used when building.\n"
  
  printf "  -a BUILDAGENT         The name of the agent. Only use if used when building. (Tradtionally Kevin)\n"

  exit $exitCode
}

if [[ "$1" == "--help" ]] || [[ $1 == "-h" ]]; then
  helpFunction 0
fi

while getopts "t:w:v:f:hl:a:" OPTIONS; do
  case "$OPTIONS" in
    t)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      TRACEFILEDIRROOT="$OPTARG"
      ;;
    w)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      WORKSPACE="$OPTARG"
      REPORTDIRECTORY="$WORKSPACE/reports"
      ;;
    v)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      MAINRELEASEVERSION="$OPTARG"
      ;;
    f)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      FULLVERSION="$OPTARG"
      ;;
    l)
      BUILDLABEL="$OPTARG"
      ;;
    a)
      BUILDAGENT="$OPTARG"
      ;;
    h)
      helpFunction 0
      ;;
    \?)
      echo "INVALID Option"
      echo "Type postJobMerge.sh -h for help!"
      exit 1
      ;;
    :)
      echo "No argument supplied!"
      echo "Type postJobMerge.sh -h pr --help for help!"
      exit 1
      ;;
  esac
done
##############################################################################
# setupWorkspace- Creates the necassary directories, copies tars for processing,
#              parses the command line arguments
##############################################################################
function setupWorkspace()
{
  printf "# MAINRELEASEVERSION : $MAINRELEASEVERSION\n"
  printf "# TRACEFILEDIRROOT   : $TRACEFILEDIRROOT\n"
  printf "# FULLVERSION        : $FULLVERSION\n"
  printf "# WORKSPACE          : $WORKSPACE\n"

  if [[ ! -d "$TRACEFILEDIRROOT" ]]; then
    printf "Tracefile directory doesn't exist!\n"
    exit 1
  else
    local deleteFiles=()
    for files in "$TRACEFILEDIRROOT/reports/**/*"; do
      if [[ files =~ *total* ]]; then
        deleteFiles+="$files "
      fi
    done
    printf "Removing: $deleteFiles\n"
    #rm "$deleteFiles"
  fi

  # The path to where the merged LCOV reports will be kept
  FINALREPORTDIRROOT="$WORKSPACE"/"$FULLVERSION"
  if [[ ! -d "$FINALREPORTDIRROOT" ]]; then
    mkdir -p $FINALREPORTDIRROOT
  fi
}
################################################################################
# mergeLcovReports - Merges lcov reports in a folder
# Parameters: $1 = The component getting merged
#             $2 = The path to the report folders
################################################################################
function mergeLcovReports()
{
  printf "#########################################\n"
  printf "# Merge Report\n"
  getTimeElapsed
  printf "#########################################\n"

  # The component name
  local component="$1"
  # The top level report directory ([...]/INCREMENTAL_COV_REPORT/reports)
  local componentTraceDir="$2"

  # The main file all other files will be merged into
  local reportTotalName="$componentTraceDir/$component.total.lcov"
  printf "  # componentTraceDir is: $componentTraceDir\n"
  local lcovCommandString="$LCOVSCRIPTS "

  # Build the lcov command We'll use, just keep appending the tracefiles to the end
  for traceFile in "$componentTraceDir"/*; do
      lcovCommandString="$lcovCommandString -a $traceFile "
  done
   lcovCommandString="$lcovCommandString --output-file $reportTotalName"
  # Run the command
  $lcovCommandString

  # Delete spent tracefiles
  local tracefilesToDelete=""
  for files in "$componentReportDirectory"/*; do
    if [[ ! $files =~ "total" ]]; then
      printf "Delete: $files\n"
    fi
  done
}
################################################################################
# convertAndMoveReportTotals
################################################################################
function convertAndMoveReportTotals()
{
  printf "#########################################\n"
  printf "# Converting and Moving report into place\n"
  printf "#########################################\n"

  # The component name
  local component="$1"
  # Where the tracefiles are
  local traceFileLocation="$2"
  # Path to the lcov.total file
  local reportTotalName="$3"

  # Grab the build root for all projects
  local buildRoot=$(dirname "$WORKSPACE")
  local jobName=$(getJobName "$component")
  # Where the report will finall settle
  local componentBuildRoot="$buildRoot"/"$jobName"/"$BUILDLABEL"/"$BUILDAGENT"/"$component"/
  local actualFinalReportName="COVERAGE-LCOV-REPORT.xml"
  local actualFinalFullPathToReport="$componentBuildRoot/$actualFinalReportName"

  # Move the lcov reports into the GEN_COVERAGE_REPORT workspace
  mv "$traceFileLocation"/"$component.total.lcov" "$reportTotalName"

  if [[ -f "$reportTotalName" ]]; then
    # Convert to corbertura
    printf "Doing the conversion\n"
    printf "$actualFinalFullPathToReport\n"
    $LCOVTOCOBERTURASCRIPT "$reportTotalName" --base-dir="$componentBuildRoot" --output="$actualFinalFullPathToReport"
  else
    printf "# No lcov file found for $component!\n"
  fi

  # Finally we want to remove the old lcov totals so they don't interfere with 
  # later runs
  local tracefilesToDelete=""
  for files in "$traceFileLocation"/*; do
      printf "PRETENDING TO REMOVE: $files\n"
      #rm "$files"
  done

}
################################################################################
# Performs asynchronous merges in batches of up to BATCHSIZE. 
# Eventally will have a single total file
################################################################################
function batchMergeReports()
{
  printf "##############################################################################\n"
  printf "# Batch merging reports in $1\n"
  printf "##############################################################################\n"

  local component="$1"
  local componentReportDirectory="$2"
  local keepMerging=1
  # If there's an error will stop infinite looping after WATCHDOGLIMIT loops.
  local watchDogCounter=0

  while [[ $keepMerging -eq 1 ]]; do
    # How many files are in the directory
    local numberOfFiles=$(ls 2>/dev/null -Ub1 -- $componentReportDirectory | wc -l)
    printf "# Files left in $component: $numberOfFiles\n"

    # Gather tracefiles
    for traceFile in $componentReportDirectory/*; do
      traceFiles+=("$traceFile ")
    done
    let count=0

    # Init our out traceFiles
    traceFilesOut=()
    local lcovCommandString="$LCOVSCRIPTS "
    # Add one because otherwise it won't work; I don't know why
    local i
    for((i=0;i<(($numberOfFiles+1));i++)); do
      # Add files to our traceFiles
      traceFilesOut+=${traceFiles[$count]}
      let count=$count+1
      let modCount=$count%$BATCHSIZE;
      # If the max batch size is reached, OR the array is at it's end
      if [[ modCount -eq 0 || i -eq ${#traceFiles[@]} ]]; then
        # Do stuff in here
        if [[ ! ${#traceFilesOut} -eq 0 ]]; then
          local reportTotalName="$componentReportDirectory/$component.total.$i.lcov"
          for traceFileOut in ${traceFilesOut[@]}; do
            lcovCommandString="$lcovCommandString -a $traceFileOut "
          done

          lcovCommandString="$lcovCommandString --output-file $reportTotalName"
          # Run command in a subshell to copy variables and still run normally
          printf "# Lcov: $lcovCommandString\n"
          ($lcovCommandString
          rm $traceFilesOut) &

          for tform in ${traceFilesOut[@]}; do
            printf "# Will be deleting: $tform\n"
          done

          # Reset variables
          lcovCommandString="$LCOVSCRIPTS "
          traceFilesOut=()
        fi
      fi
    done

    wait

    numberOfFiles=$(ls 2>/dev/null -Ub1 -- $componentReportDirectory | wc -l)
    # If there's only one file left this must be the final total file, so rename, and break out of the loop
    if [[ numberOfFiles -eq 1 ]]; then
      local totNum
      let totNum=$i-1
      printf "# Moving to merged total to workspace\n"
      mv "$componentReportDirectory/$component.total.$totNum.lcov" "$componentReportDirectory/$component.total.lcov"
      keepMerging=0
    elif [[ numberOfFiles -gt 1 ]]; then
      # If there are more files left return true to continue looping
      # re-Gather tracefiles, including the new total files
      traceFiles=()
      keepMerging=1
    elif [[ numberOfFiles -lt 1 ]]; then
      # There are no files present in the directory, something has gone wrong
      printf "# Something has gone wrong. No Files present anymore in $componentReportDirectory\n"
    fi

    printf "End of While loop ($component): KM: $keepMerging NF: $numberOfFiles WD: $watchDogCounter\n"
    if [[ watchDogCounter -gt $WATCHDOGLIMIT ]]; then
      break
    else
      let watchDogCounter++
    fi

  done
}
################################################################################
# Main - Entry point for our program
################################################################################
function main()
{
  printf "##############################################################################\n"
  printf "# LCOV Tracefile POST test merger\n"
  printf "##############################################################################\n"

  setupWorkspace

  for component in "${COMPONENTLIST[@]}"; do
    local compRepDir="$TRACEFILEDIRROOT/reports/$component/"
    local reportTotalName="$FINALREPORTDIRROOT/$component.total.lcov"

    batchMergeReports "$component" "$compRepDir" &
    wait

    convertAndMoveReportTotals "$component" "$compRepDir" "$reportTotalName"
  done
}

main
