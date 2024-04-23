#! /usr/bin/env python

from sys import argv
from treeswift import *

with open(argv[1],'r') as fin:
    with open(argv[3],'w') as fout:
        for line in fin:
            T = read_tree_newick(line.strip())
            T.collapse_short_branches(float(argv[2]))
            fout.write(T.newick()+"\n")

