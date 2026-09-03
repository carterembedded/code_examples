#!/bin/bash

VERSION="One-NDS-SONAR-RHEL74-19.0.0-CI270"

CINUMBER="$(echo $VERSION | cut -d'-' -f6)"

echo $CINUMBER
