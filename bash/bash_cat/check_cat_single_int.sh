#!/bin/bash

echo "1" > status_file

if [ $(cat status_file) -eq 1 ]; then
    echo "I got 1!"
fi
