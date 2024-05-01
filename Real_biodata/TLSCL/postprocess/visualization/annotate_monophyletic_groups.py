#! /usr/bin/env python

from sys import argv
from treeswift import *

inputtree = argv[1]
labelFile = argv[2]
outputtree = argv[3]

T = read_tree_newick(inputtree)

node2labels = {}
with open(labelFile,'r') as fin:
    fin.readline() # ignore header
    for line in fin:
        name,label = line.strip().split()
        node2labels[name] = label

for node in T.traverse_postorder():
    if node.is_leaf():
        node.prog_label = node2labels[node.label]    
    else:
        L = set([cnode.prog_label for cnode in node.children])
        if len(L) == 1:
            node.prog_label = L.pop()
        else:
            node.prog_label = None
        node.label = node.prog_label

T.write_tree_newick(outputtree)                
