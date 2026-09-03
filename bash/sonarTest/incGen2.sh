#!/bin/bash

# Contains a functions and constants related to both the incremental generation and postJobMerge Scripts
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
source $scriptDir/commonCoverageFunctions.sh

# incrementalGeneration.sh
# Author: Harrison James 'Harry' Marcks

# This script is used at the end of every job to generate the gcov/lcov results
# that will later be merged as a part of the postJobMerge.sh script

# Get and extract the nodes tars
    # We need the FULL job AND task number for this
# Sync each nodes files into place SEQUENTIALLY and generate the tracefile
    # Each component can be done in parallel, but each node must be sequential
    # run an instance of lcov inside each source folder
      # I don't think I can make the script too file  agnostic
# Make sure the tracefiles are in ${WORKSPACE}/reports/${component}/*

# The agent and label directory names
BUILDLABEL=""
BUILDAGENT=""
# This is where we are storing the tars after a job in RTest is completed
TARORIGINDIR="/mnt/fs01.brs/home/tester.nds/coverage/"
# This is the component root of where we will be storing the tracefiles
# Get this from a command line argument, -w
COVERAGEWORKSPACE=""
# This is where the reports will be stored. Derived as a aprt of the options
REPORTDIR=""
# This is the top level JOB root (/mnt/fs01.brs/nightlybuild/sles11-x86/workspace/)
# Get this from a command line argument, -s
BUILDROOT=""
# This will store the RTest job and task number (...CI253_122886_490374...)
# We want the last two numbers seperated by _
JOBNUMBER="" # First number, i.e. 122886, -j
TASKNUMBER="" # second number, i.e. 490374, -t
# This variable counts the number of tracefiles generated. Stops dupication/overwriting
TRACEFILECOUNTER=0
# This defines the lockfile extension we'll be using each folder will use
LOCKFILELOCATION="/tmp/gcovlocks/"

# The path to the LCOV script. Variable gotten from sourced file, 
# NB Trailing "safety" space
LCOVSCRIPTS="$__LCOV "

##############################################################################
# helpFunction - Displays help text to the user; documenting the switches
# Parameters: $1= the code to exit with
##############################################################################
function helpFunction
{
  local exitCode="$1"
  printf "usage: incrementalGeneration.py [-h] [-w WORKSPACEROOT] [-s BUILDROOT]\n"
  printf                                 "[-v MAINRELEASEVERSION] [-j JOBNUMBER]\n"
  printf                                 "[-t TASKNUMBER]\n\n"

  printf "LCOV incremental tracefile Generator\n\n"

  printf "optional arguments:\n"
  printf "  -h, --help            show this help message and exit\n"
  printf "  -w WORKSPACEROOT      The absolute path to the nominated work space. This is\n"
  printf "                        where tars,reports, merges, etc are handled.\n"
  printf "  -s BUILDROOT          The absolute path to the top level source directory.\n"
  printf "                        The folder that contains all projects,\n"
  printf "                        i.e. ASN-1_19_SONAR/..\n"
  printf "  -v MAINRELEASEVERSION\n"
  printf "                        The current Main Version of NDS. i.e. 16/16.5/17/19\n"
  printf "                        This is used to help build the paths\n"

  printf "  -j JOBNUMBER          The main job number from RTest. All tars will have\n"
  printf "                        this number\n"

  printf "  -t TASKNUMBER         The task number from RTest. This will be unique every\n"
  printf "                        6 nodes\n"
  printf "  -l BUILDLABEL              The label given (usually just 'label'). Only use if used when building.\n"
  
  printf "  -a BUILDAGENT         The name of the agent. Only use if used when building\n"
  exit $exitCode
}

if [[ "$1" == "--help" ]] || [[ $1 == "-h" ]]; then
  helpFunction 0
fi

while getopts "w:s:v:j:t:f:hl:a:" OPTIONS; do
  case "$OPTIONS" in
    w)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      WORKSPACEROOT="$OPTARG"
      REPORTDIRECTORY="$WORKSPACEROOT/reports"
      ;;
    s)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      BUILDROOT="$OPTARG"
      ;;
    v)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      MAINRELEASEVERSION="$OPTARG"
      ;;
    j)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      JOBNUMBER="$OPTARG"
      ;;
    t)
      OPTARGCheck "$OPTARG" "$OPTIONS"
      TASKNUMBER="$OPTARG"
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
      echo "Type incGen2.sh -h for help!"
      exit 1
      ;;
    :)
      echo "No argument supplied!"
      echo "Type incGen2.sh -h or --help for help!"
      exit 1
      ;;
  esac
done

################################################################################
# setupWorkspace - Creates the necassary directories and copies
#                  tars for processing
################################################################################
function setupWorkspace
{
  printf "################################################################################\n"
  printf "# Setting up the Workspace\n"
  printf "################################################################################\n"

  printf "# MAINRELEASEVERSION : $MAINRELEASEVERSION\n"
  printf "# WORKSPACEROOT      : $WORKSPACEROOT\n"
  printf "# REPORTDIRECTORY    : $REPORTDIRECTORY\n"
  printf "# BUILDROOT          : $BUILDROOT\n"
  printf "# JOBNUMBER          : $JOBNUMBER\n"
  printf "# TASKNUMBER         : $TASKNUMBER\n"

  if [[ ! -d "$WORKSPACEROOT" ]]; then
    printf "# Making workspace directory\n"
    mkdir "$WORKSPACEROOT"
  fi
  if [[ ! -d "$REPORTDIRECTORY" ]]; then
    printf "# Creating report directory\n"
    mkdir "$REPORTDIRECTORY"
  else
    rm -rf "$REPORTDIRECTORY/*"
  fi

  if [[ ! -d "$LOCKFILELOCATION" ]]; then
    printf "# Creating lock directory\n"
    mkdir "$LOCKFILELOCATION"
  fi

  # copy all relevant tars to the workspace
  printf "# Copying tars into workspace directory\n"
  cp "$TARORIGINDIR"/*$TASKNUMBER*.tar.gz "$WORKSPACEROOT"

  TRACEFILCOUNTERFILE="$WORKSPACEROOT"/TRACEFILECOUNT.tmp
  echo $TRACEFILECOUNTER > $TRACEFILCOUNTERFILE
}

################################################################################
# mergeLcovReports - Merges lcov reports in a folder
# Parameters: $1 = The component getting merged
#             $2 = The path to the report folders
################################################################################
function mergeLcovReports
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
  printf "  # Building lcov command..."
  for traceFile in "$componentTraceDir"/*; do
      lcovCommandString="$lcovCommandString --add-tracefile $traceFile "
  done
  lcovCommandString="$lcovCommandString --output-file $reportTotalName"

  # Run the command
  printf "  # Runnign lcov tracefile merge..."
  $lcovCommandString

  # Delete spent tracefiles
  local tracefilesToDelete=""
  for files in "$componentReportDirectory"/*; do
    if [[ ! $files =~ "total" ]]; then
      rm "$files"
    fi
  done
}

#############################################################################
# gatherReports - uses find to gather all the reports and then merges them all together
# parameters: $1, componentRoot, the root of the component source
#             $2, component,
#############################################################################
function gatherReports
{
  local componentRoot=$1
  local component=$2

  mkdir $componentRoot/reports/

  find "$componentRoot" -name '*.lcov' -exec mv -t "$componentRoot/reports/" {} +
}

################################################################################
# syncGCDAAndGenerateLcovThread:  moves/copies the GCDA files into the correct place in the
#               original build source
# Parameters $1 = component, the component we want to process
################################################################################
function syncGCDAAndGenerateLcovThread
{
  local component="$1"
  printf "    ################################################################################\n"
  printf "    # Processing component: $component\n"
  printf "    ################################################################################\n"

  local jobName=$(getJobName "$component")
  # The actual build location
  local componentBuildRoot="$BUILDROOT"/"$jobName"/"$BUILDLABEL"/"$BUILDAGENT"/
  printf "    # Build root of the component: $componentBuildRoot\n"
  # This will become the components GCDA location, this is in fact the untarred file
  local extractedNodeComponentDir="$WORKSPACEROOT"/"$componentBuildRoot"
  printf "    # Path to the extracted nodes GCDAs: $extractedNodeComponentDir\n"
  # The location of the generated reports
  local componentReportDirectory="$REPORTDIRECTORY"/"$component"
  printf "    # Path to where the reports will go: $componentReportDirectory\n"

  # Lcov cannot create the directories itself, so we have to
  if [[ ! -d "$componentReportDirectory" ]]; then
    printf "    # Creating new component directory\n"
    mkdir "$componentReportDirectory"
  fi

  local counter=$[$(cat $TRACEFILCOUNTERFILE)]
  # If the component has a folder in the extracted node then we want to
  # sync all the files to the build directory
  printf "    # Extracted Component Directory: $extractedNodeComponentDir\n"
  if [[ -d "$extractedNodeComponentDir" ]]; then
    # Delete old GCDAs if present
    printf "    # Deleting old GCDAs in $component (if present)\n"
    find "$componentBuildRoot" \( -name '.gcda' \) -delete
    # Sync new GCDA files into place
    printf "    # Syncing files into the required locations\n"
    rsync -acv --filter='+ */' --filter='+ *.gcda' --filter='- *' $extractedNodeComponentDir $componentBuildRoot\
    | sed 's/^/    # /'
    # Generate LCOV files
    local LcovReportFile="$component.$TASKNUMBER.$counter.lcov"
    printf "    # Capturing Gcov results in: $componentBuildRoot/$LcovReportFile\n"
    ($LCOVSCRIPTS --capture --directory $componentBuildRoot --output-file $componentReportDirectory/$LcovReportFile --gcov-tool /usr/bin/gcov\
    | sed 's/^/    # /')

    let counter++
    echo "$counter" > "$TRACEFILCOUNTERFILE"
  fi
}
################################################################################
# syncGCDAAndGenerateLcov:  wrapper function for calling for seperate processes
#                           for each component
################################################################################
function syncGCDAAndGenerateLcov
{
  printf "  ################################################################################\n"
  printf "  # Processing components in tarball\n"
  getTimeElapsed | sed 's/^/  # /'
  printf "  ################################################################################\n"

  local component
  local jobsList=""
  for component in "${COMPONENTLIST[@]}"; do
    syncGCDAAndGenerateLcovThread "$component" &
    jobsList+="$! "
  done

  wait

  # Delete untarred directory as it has now been processed
  printf "    # Deleting processed node\n"
  rm -rf "$WORKSPACEROOT"/mnt/
}
################################################################################
# processTarFile: Extracts a single tar file into the reports directory
# Parameters: $1 = TARBALL path
################################################################################
function processTarFile
{
  printf "  ################################################################################\n"
  printf "  # Processing Tar File *\n"
  getTimeElapsed | sed 's/^/  # /'
  printf "  ################################################################################\n"

  local tarBallPath=$1

  printf "  # Tarball to extract: $tarBallPath\n"
  if [[ -f "$tarBallPath" ]]; then

    tar -zxf $tarBallPath -C "$WORKSPACEROOT"
    # Remove tarball after untarring
    rm -f $tarBallPath
  fi

  syncGCDAAndGenerateLcov
}
################################################################################
# processGCDAS -  ths function will serve to loop over every tar ball in
#                 the directory
################################################################################
function process
{
  printf "################################################################################\n"
  printf "# Beginning processing \n"
  getTimeElapsed | sed 's/^/# /'
  printf "################################################################################\n"

  local tarBall
  for tarBall in "$WORKSPACEROOT/"*; do
    if [[ -f "$tarBall" ]] && [[ "$tarBall" =~ .*".tar.gz" ]]; then
      printf "# Tar file: $tarBall\n"
      processTarFile "$tarBall"
    fi
  done
}
################################################################################
# cleanUp - deletes all files generated by the script
#           (i.e. lck files, lcov files, gcda files, report directories)
################################################################################
function cleanUp
{
  rm $TRACEFILCOUNTERFILE

  for component in "${COMPONENTLIST[@]}"; do
    local jobName=$(getJobName "$component")
    # The actual build location
    local componentBuildRoot="$BUILDROOT"/"$jobName"/"$BUILDLABEL"/"$BUILDAGENT"/

    find "$componentBuildRoot" -name '*.lcov' -delete
    find "$componentBuildRoot" -name '*.gcda' -delete
    find $LOCKFILELOCATION -name '*.gcov.lck' -delete
  done
}
################################################################################
# main - The "entry point".
################################################################################
function main
{
  printf "################################################################\n"
  printf "# Incremental LCOV Tracefile Generator\n"
  printf "################################################################\n\n"
  # We start here
  setupWorkspace
  process

  printf "# Removing tars in workspace directory\n"
  rm -rf "$WORKSPACEROOT"/*.tar.gz

  cleanUp

  printf "# Incremental files generated"
  getTimeElapsed | sed 's/^/# /'

  printf "\n"
}

main
