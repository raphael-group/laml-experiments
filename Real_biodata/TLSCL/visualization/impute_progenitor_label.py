#! /usr/bin/env python

from treeswift import *
from sys import argv

T = read_tree_newick(argv[1])

with open(argv[2],'w') as fout:
    fout.write("CellIDs\tImputed\n")
    for node in T.root.children:
        for cnode in node.traverse_leaves():
            fout.write(cnode.label+"\t" + node.label+"\n")
