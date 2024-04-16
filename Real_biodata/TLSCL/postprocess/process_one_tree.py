#! /usr/bin/env python

from sys import argv
from treeswift import *
import numpy as np
from sklearn.mixture import GaussianMixture
from math import log,exp

def gmm2_break(data):
    gm = GaussianMixture(n_components=2, random_state=0).fit(data)
    c = gm.predict(data)

    max_0 = -float("inf")
    max_1 = -float("inf")

    for i,c_i in enumerate(c):
        x = data[i][0]
        if c_i == 1: 
            max_1 = max(max_1,x)
        else: 
            max_0 = max(max_0,x)
    return min(max_0,max_1)

def main():
    T = read_tree_newick(argv[1])
    T.suppress_unifurcations()
    # step 1: collapse short branches
    brlens = np.array([[log(node.edge_length)] for node in T.traverse_preorder() if node.edge_length is not None])
    #threshold = exp(gmm2_break(brlens))
    threshold = 0.009 # pre-computed using gmm on branch lengths of all trees combined
    print("Branch threshold: " + str(threshold))
    T.collapse_short_branches(threshold)

    lb2prog = {}
    with open(argv[2],'r') as fin:
        fin.readline() # ignore header
        for line in fin:
            cell,prog = line.strip().split()
            lb2prog[cell] = prog
    # step 2: split the clades under root node into multiple trees and identify the progenitor of each
    root_edge_length = T.root.edge_length if T.root.edge_length is not None else 0
    root_list = [node for node in T.root.children]
    prog2trees = {}
    moving_list = []
    for node in root_list:
        T.root.remove_child(node)
        node.edge_length += root_edge_length
        T_new = Tree()
        T_new.root = node
        prog_counts = {'?':0}
        for x in T_new.traverse_leaves():
            prog = lb2prog[x.label]
            prog_counts[prog] = 1 if prog not in prog_counts else prog_counts[prog]+1
        prog_group = None
        max_count = 0
        for prog in prog_counts:
            if prog != '?' and prog_counts[prog] > max_count:
                max_count = prog_counts[prog]
                prog_group = prog
        if prog_group is None or max_count / (max_count+prog_counts['?']) < 1/10:
            prog_group = '?'            
        print(prog_counts,prog_group)
        if prog_group == '?' and len(prog_counts.keys())>1:
            moving_list += [x for x in T_new.traverse_leaves() if lb2prog[x.label] != '?']         
        if prog_group not in prog2trees:
            prog2trees[prog_group] = [T_new]
        else:
            prog2trees[prog_group].append(T_new)    

    # step 3: add the nodes in moving list to the correct groups
    for node in moving_list:
        prog_group = lb2prog[node.label]
        node.parent.remove_child(node)
        T_new = Tree()
        T_new.root = node 
        prog2trees[prog_group].append(T_new)

    # step 4: merge trees that share a same progenitor
    tree_list = []
    for prog_group in prog2trees:
        if prog_group == '?':
            tree_list += [('?',T) for T in prog2trees[prog_group]]
        else:    
            T_merge = Tree()
            for T in prog2trees[prog_group]:
                T_merge.root.add_child(T.root)
            tree_list.append((prog_group,T_merge))
    # final step: output
    with open(argv[3],'w') as fout:
        for g,T in tree_list:
            fout.write(g + " " + T.newick()+"\n")

if __name__ == "__main__":
    main()            
