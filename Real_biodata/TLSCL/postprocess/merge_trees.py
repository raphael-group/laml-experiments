#! /usr/bin/env python

from sys import argv
from treeswift import *

treeList = []
with open(argv[1],'r') as fin:
    for line in fin:
        T = read_tree_newick(line.strip())
        T.suppress_unifurcations()
        treeList.append(T)
lb2prog = {}
with open(argv[2],'r') as fin:
    fin.readline() # ignore header
    for line in fin:
        cell,prog = line.strip().split()
        lb2prog[cell] = prog

T_merge = Tree()
for T in treeList: 
    T_merge.root.add_child(T.root)

for node in T_merge.traverse_postorder():
    if node.is_root():
        continue
    if node.is_leaf():
        node.prog = lb2prog[node.label]
    else:
        node.prog = '?'
        for cnode in node.children:
            if cnode.prog != '?':
                node.prog = cnode.prog
                break
        if node.parent.is_root():
            node.label = node.prog
        else:
            node.label = None         

T_merge.write_tree_newick(argv[3])
