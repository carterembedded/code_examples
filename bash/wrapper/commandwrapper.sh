#!/bin/sh

commandwrapper() {
    exec $1 $@
    if [ $? != 0 ]; 
    then
        set_fail
    fi
}

commandwrapper /bin/ls -al
