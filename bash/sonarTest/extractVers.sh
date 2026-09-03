#!/bin/bash

BUILD="one-NDS-SONAR-RHEL74-19.0.0-CI7"

regex="-([0-9]+)\.*"

if [[ $BUILD =~ $regex ]]; then
  MAJORVERSION="${BASH_REMATCH[1]}"
  echo $MAJORVERSION
else
  echo "BOOOO!"
fi
