#!/bin/bash


VERSIONR="One-NDS-SONAR-RHEL74-19.0.0-CI270"
VERSIONS="One-NDS-SONAR-SLES11-19.0.0-CI270"

if [[ $VERSIONR = *"RHEL"* ]]; then
  echo "WE HAVE A THING WHAT WITH THE REHL"
fi

if [[ $VERSIONR = *"SLES"* ]]; then
  echo "I shouldn't be wroking!"
fi

if [[ $VERSIONS = *"RHEL"* ]]; then
  echo "I shouldn't be wroking!"
fi

if [[ $VERSIONS = *"SLES"* ]]; then
  echo "WE HAVE A THING WHAT WITH THE sles"
fi
