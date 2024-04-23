#! /usr/bin/env python

from sys import argv
from treeswift import *

input_clusters = argv[1]
root_map = {}

with open(input_clusters,'r') as fin:
    fin.readline() # skip header
    for line in fin:
        lb,cluster = line.strip().split()
        if cluster == '?':
            continue
        if cluster not in root_map:
            T_new = Tree()
            root_map[cluster] = T_new
        T = root_map[cluster]
        node = Node()
        node.label = lb
        T.root.add_child(node)

T_merge = Tree()
for cluster in root_map:
    T_merge.root.add_child(root_map[cluster].root)

T_merge.write_tree_newick(argv[2]) 

