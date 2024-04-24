#! /usr/bin/env python

from sys import argv
from treeswift import *

inputfile=argv[1]
outputfile=argv[2]

#typeMap = {'PCGLC':'PCGLC','Endoderm':'Endoderm','NeuralTube1':'Neural','NeuralTube2':'Neural','SomiteSclero':'Sclerotome','SomiteDermo':'Dermomyotome','Somite0':'Early_somite','Somite-1':'Early_somite','Somite':'Early_somite','aPSM':'Early_somite','pPSM':'Early_somite','NMPs':'NMP'}
#typeMap = {'PCGLC':'PCGLC','Endoderm':'Endoderm','NeuralTube1':'Neural','NeuralTube2':'Neural','SomiteSclero':'Somite','SomiteDermo':'Somite','Somite0':'Somite','Somite-1':'Somite','Somite':'Somite','aPSM':'Early_somite','pPSM':'Early_somite','NMPs':'NMP'}
typeMap = {'PCGLC':'PCGLC','Endoderm':'Endoderm'}

T = read_tree_newick("cell_state_tree_simplest.nwk")
#T = read_tree_newick("cell_state_tree_simplified.nwk")
typeRootNode = {}
for node in T.traverse_preorder():    
    typeRootNode[node.label] = node # assume each node of T has a unique label, which is also its cell type

with open(inputfile,'r') as fin:
    fin.readline() # ignore header
    for line in fin:
        cellname,celltype = line.strip().split()
        celltype = typeMap[celltype] if celltype in typeMap else "NMP"
        u = typeRootNode[celltype]
        v = Node()
        v.label = cellname
        u.add_child(v)

for nodeType in typeRootNode:
    v = typeRootNode[nodeType]
    if v.is_leaf():
        v.parent.remove_child(v)

T.suppress_unifurcations()

T.write_tree_newick(outputfile)        
