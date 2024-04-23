#! /usr/bin/env python

from sys import argv
from treeswift import *

T_merge = Tree()
with open(argv[1],'r') as fin:
    for line in fin:
        T = read_tree_newick(line.strip())
        T.collapse_short_branches(float(argv[2]))
        T_merge.root.add_child(T.root)

T_merge.write_tree_newick(argv[3])
