#!/bin/bash -x

#This was originally in the build step itself but was removed to stop/prevent spam in the terminal

# We need to make sure that all the reports are generated before we run this.
# This script here will poll the INCREMENTAL_COV_REPORT JOB every 7 seconds.
# looping until all jobs are finished. Once done it will continue with the script

#JOB_URL=https://hudson.sdm.nsn-rdnet.net/job/INCREMENTAL_COV_REPORT/
JOB_URL=$1
JOB_STATUS_URL=${JOB_URL}/lastBuild/api/json
WGET_OPTIONS=" --no-check-certificate --user=andon --password=500tps --auth-no-challenge -q -O- "
GREP_RETURN_CODE=0

# Polly the incremmental build every 5 seconds waiting for it to finish
while [ "$GREP_RETURN_CODE" -eq 0 ];
do
  sleep 60
  # Grep will return 0 while the build is running:
  result=$(wget "$JOB_STATUS_URL" $WGET_OPTIONS)
  echo $result | grep result\":\"S && if [ $? == 0 ]; then
        GREP_RETURN_CODE=1
     fi

done
