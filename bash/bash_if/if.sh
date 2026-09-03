#!/bin/bash
target=$1
arch=$2
osname="end"
targetarch="x86_foo"
archname=fallthrough

msg() {
    echo $@
}

tryhints() {
    echo hinting $1
}

if [ -n $target ] && [ $target = "morello" ]; then
    msg "target is $target"
    msg "targetarch is $targetarch"
    msg "arch is $archname"
    msg "arch is $arch"
    if [ -n $arch ] && [ $arch != "x86_64" ]; then
        tryhints $target
    fi
else
    tryhints "$archname"
fi
tryhints "$osname"