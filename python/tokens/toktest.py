#!/usr/bin/env python

# "07/Aug/23 4:48 PM;62c206f6efb17d6ce62e0dfe;!20230807_155237.jpg|width=4000,height=3000!\n\n!20230807_155026.jpg|width=3000,height=4000!\n\n!20230807_155221.jpg|width=3000,height=4000!\n\n!20230807_155036.jpg|width=3000,height=4000!\n\n!20230807_155048.jpg|width=3000,height=4000!\n\n!20230807_155010.jpg|width=3000,height=4000!\n\n!20230807_155227.jpg|width=3000,height=4000!",
summary = "07/Aug/23 4:48 PM;62c206f6efb17d6ce62e0dfe;!20230807_155237.jpg|width=4000,height=3000!\n\n!20230807_155026.jpg|width=3000,height=4000!\n\n!20230807_155221.jpg|width=3000,height=4000!\n\n!20230807_155036.jpg|width=3000,height=4000!\n\n!20230807_155048.jpg|width=3000,height=4000!\n\n!20230807_155010.jpg|width=3000,height=4000!\n\n!20230807_155227.jpg|width=3000,height=4000!"
summary = "* 1x thing X carrier board\n* 1x 4GB IT (SN: DEADBEEF)\n* 1x 4GB IT (SN: DEADBEEF)\n* 1x heatsink\n* 1x RS232 serial adapter cable\n\n\n!IMG_20260811_093517979.jpg|width=1087,alt=\"IMG_20260811_093517979.jpg\"!\n!IMG_20260811_093705452.jpg|width=1087,alt=\"IMG_20260811_093705452.jpg\"!\n!IMG_20260811_093712704.jpg|width=1087,alt=\"IMG_20260811_093712704.jpg\"!\n!IMG_20260811_093453024.jpg|width=1087,alt=\"IMG_20260811_093453024.jpg\"!\n!IMG_20260811_093652272.jpg|width=1087,alt=\"IMG_20260811_093652272.jpg\"!\n!IMG_20260811_093852599.jpg|width=1087,alt=\"IMG_20260811_093852599.jpg\"!\n!IMG_20260811_093617219.jpg|width=1087,alt=\"IMG_20260811_093617219.jpg\"!\n!IMG_20260811_093856262.jpg|width=1087,alt=\"IMG_20260811_093856262.jpg\"!\n\n"

toks = summary.split('!')
body_text = ""
filenames = []
if len(toks) > 1:
    # we have an inline file
    for tok in toks:
        print(tok)
        print(len(tok))
        if '|' in tok:
            file_name = tok.split('|')[0]
            print(file_name)
            continue

        if len(tok) > 1:
            body_text = body_text + "\n" + tok

    print(body_text)