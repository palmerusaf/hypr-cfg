#!/usr/bin/env python

import re
import sys


def main():
    vtt_file_name = sys.argv[1]
    txt_name = re.sub(r".vtt$", ".txt", vtt_file_name)
    with open(vtt_file_name) as f:
        text = f.read()
    lines = text.splitlines()
    # rem title
    lines = lines[1:]
    # only write every fourth line
    with open(txt_name, "w") as f:
        for i in range(len(lines)):
            if (i + 1) % 4 == 0:
                line = lines[i]
                f.write(line)
                f.write(" ")


if __name__ == "__main__":
    main()
