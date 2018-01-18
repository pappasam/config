'''Adds propercase to linux words

use: python3 /usr/share/dict/words | sort > my_words_with_propcase
'''
import sys

path_infile = sys.argv[1]

with open(path_infile, 'r') as infile:
    for line in (l.replace('\n', '') for l in infile):
        print(line)
        if line[0].islower():
            print(line[0].upper() + line[1:])
