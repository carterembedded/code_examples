#!/bin/bash


COUNTER=0
echo "zero: $COUNTER"

let COUNTER++
echo "inc: $COUNTER"

let COUNTER++
echo "inc: $COUNTER"

let COUNTER++
echo "inc: $COUNTER"

let COUNTER++
echo "inc: $COUNTER"

let COUNTER+1
echo "add: $COUNTER"

let COUNTER=2
echo "set/let: $COUNTER"

let COUNTER=$COUNTER+1
echo "Self ref: $COUNTER"




