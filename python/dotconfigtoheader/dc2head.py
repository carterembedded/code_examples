#!/usr/bin/env python
from datetime import date, datetime
import sys
from enum import Enum
from operator import contains
from time import time

class linetype(Enum):
    NULL = 0,
    NOT_SET = 1,
    COMMENT = 2,
    CONFIG_BOOL_LINE = 3,
    CONFIG_STRING_LINE = 4,
    CONFIG_NUMBER_LINE = 5,

progname = sys.argv[0]
src = sys.argv[1]
dst = sys.argv[2]

with open(src) as in_file:
    with open(dst, 'a') as out_file: 
        out_file.write("// Automatically generated ({}). Your concerns are meaningless.\n\n".format(datetime.now()))
        arb_name = dst.split('.')[0]
        out_file.write("#ifndef __{}_H__\n".format(arb_name))
        out_file.write("#define __{}_H__\n\n".format(arb_name))

        for line in in_file:
            ltype = linetype.NULL

            if line[0] == '#':
                ltype = linetype.COMMENT

            elif line.count("\"") >= 2:
                ltype = linetype.CONFIG_STRING_LINE

            elif line.count("=y") == 1:
                ltype = linetype.CONFIG_BOOL_LINE

            elif line[0] == '\n':
                ltype = linetype.NOT_SET

            else:
                ltype = linetype.CONFIG_NUMBER_LINE

            if(ltype == linetype.COMMENT or ltype == linetype.NOT_SET):
                continue

            tokens = line.split("=", 1)

            final_line = ""
            final_line += "#define "
            print("tokens: {}".format( tokens))
            final_line += tokens[0] + " "
            final_line += tokens[1]
            out_file.write(final_line)

        out_file.write("#endif /*__{}_H__*/\n\n".format(arb_name))



