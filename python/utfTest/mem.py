#!/usr/bin/python

import sys, getopt, unicodedata

WIDE_MAP = dict((i, i + 0xFEE0) for i in xrange(0x21, 0x7F))
WIDE_MAP[0x20] = 0x3000

def main(argv):
    inputString=""
    outString=""

    try:
        opts, args = getopt.getopt(argv,"s:")
    except getopt.GetoptError:
        print "oopsy daisy"
        sys.exit(2)

    inputString = args[0]
    inputString = widen(inputString)

    i = 0
    for char in inputString:
        outString = outString + ";l]'[" + char

    print outString

def widen(s):
    return unicode(s).translate(WIDE_MAP)

if __name__ == "__main__":
    main(sys.argv[1:])
