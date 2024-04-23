#! /usr/bin/env python

from sys import argv 
from treeswift import *

def get_augmented_tree(T,placement_site,Tp):
    node = placement_site
    if node.is_root():
        node.add_child(Tp.root)
    else:    
        new_node = Node()
        new_node.add_child(Tp.root)
        pnode = node.parent
        pnode.remove_child(node)
        pnode.add_child(new_node)
        new_node.add_child(node)   
    augmented_str = T.newick()
    # turn back
    if node.is_root():
        node.remove_child(Tp.root)
    else:    
        pnode.remove_child(new_node)
        new_node.remove_child(node)   
        pnode.add_child(node)
    return augmented_str

def main():
    input_trees = argv[1]
    placement_groups = argv[2]
    output_prefix = argv[3]

    T_list = []
    with open(input_trees,'r') as fin:
        for line in fin:
            T_list.append(read_tree_newick(line.strip()))
    T_merge = Tree()
    for T in T_list:
        T_merge.root.add_child(T.root)        
    T_merge.suppress_unifurcations()

    Tps = []
    with open(placement_groups,'r') as fin:
        for line in fin:
            Tps.append(read_tree_newick(line.strip()))

    augmented_tree_strs = [T_merge.newick()]
    for Tp in Tps:
        new_augmented_tree_strs = []
        for tree_str in augmented_tree_strs:
            T = read_tree_newick(tree_str)
            placement_sites = [node for node in T.traverse_preorder()]
            for ps in placement_sites:
                augmented_str = get_augmented_tree(T,ps,Tp)
                new_augmented_tree_strs.append(augmented_str)
        augmented_tree_str = new_augmented_tree_strs           

    for i,treestr in enumerate(augmented_tree_str):
        T = read_tree_newick(treestr)
        with open(output_prefix+"_"+str(i+1)+".nwk",'w') as fout:
            for node in T.root.children:
                fout.write(node.newick()+";\n")

if __name__ == "__main__":
    main()    
