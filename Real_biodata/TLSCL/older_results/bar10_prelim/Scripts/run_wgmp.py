import pandas as pd
import numpy as np
import argparse
import networkx as nx
from collections import defaultdict, deque
from Bio import Phylo

def is_leaf(T, node):
    return len(T[node]) == 0


"""
Runs maximum parsimony for a single character.

Inputs:
  - root: root node
  - character_set: set of possible characters
"""
def mp(T, root, character_set, leaf_f, dist_f):
    # if character_set is empty, set to something
    if len(character_set) == 0:
        character_set = {'x'}

    num_labeled_leaves = 0
    unique_labels = set()
    scores = defaultdict(dict) # map from node x char -> score i.e. d(T_v, x) 
    stack = deque([root]) # stack to simulate DFS search

    while stack:
        node = stack.pop()

        if is_leaf(T, node):
            if leaf_f(node) is None:
                for char in character_set:
                    scores[node][char] = 0
                continue
            else:
                num_labeled_leaves += 1
                unique_labels.add(leaf_f(node))

            for char in character_set:
                if char == leaf_f(node):
                    scores[node][char] = 0
                else:
                    scores[node][char] = np.inf

            continue

        # all children are scored
        if all(child in scores for child in T[node]):
            for char in character_set:
                cost = 0
                for child in T[node]:
                    costs = [dist_f(char, child_char) + scores[child][child_char] for child_char in character_set]
                    cost += min(costs)
                scores[node][char] = cost
            continue

        else: 
            stack.append(node)
            for child in T[node]:
                stack.append(child)
                
    return scores[root], len(unique_labels), num_labeled_leaves

def from_newick_get_nx_tree(tree_path):
    phylo_tree = Phylo.read(tree_path, 'newick')
    net_tree = Phylo.to_networkx(phylo_tree)

    # new_net_tree = net_tree.copy()
    node_renaming_mapping = {}
    idx = 0
    for node in net_tree.nodes:
        if str(node) == 'Clade':
            node_renaming_mapping[node] = f'clade_{idx}'
            idx = idx + 1
        else:
            node_renaming_mapping[node] = node.name
    node_renaming_mapping[list(net_tree.nodes)[0]] = 'root'
    
    net_tree = nx.relabel_nodes(net_tree, node_renaming_mapping)

    directed_tree = nx.DiGraph()
    directed_tree.add_edges_from(list(nx.bfs_edges(net_tree, 'root')))
    return directed_tree

def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Performs maximum parsimony."
    )

    parser.add_argument(
        "tree"
    )

    parser.add_argument(
        "clone_tsv"
    )

    return parser.parse_args()

if __name__ == "__main__":
    args = parse_arguments()

    #print(args, flush=True)

    tree = from_newick_get_nx_tree(args.tree)
    clone_tsv = pd.read_csv(args.clone_tsv, sep=",")

    clone_tsv = clone_tsv.rename(columns=lambda x: x.strip())
    clone_tsv[clone_tsv.columns] = clone_tsv.apply(lambda x: x.astype(str).str.strip())
    
    clone_tsv.set_index("CellIDs", inplace=True)

    def dist_f(x, y):
        if x is None or y is None:
            return 0

        if x == y:
            return 0

        return 1

    character_set0 = clone_tsv[clone_tsv["LentiBarcode"] != "Negative"]
    character_set = character_set0[character_set0["LentiBarcode"] != "Doublet"]["LentiBarcode"].unique()
    #index, counts = np.unique(clone_tsv["LentiBarcode"].values, return_counts=True)


    leaf_f = lambda node: None if ((y := clone_tsv.loc[node, "LentiBarcode"]) == "Negative" or clone_tsv.loc[node, "LentiBarcode"] == "Doublet") else y 

    #res = mp(tree, "root", character_set, leaf_f, dist_f)
    res, num_unique_labels, num_labeled_leaves = mp(tree, "root", character_set, leaf_f, dist_f)
    #print(str(min(res.values())))
    print(str(min(res.values())) + "," + str(num_unique_labels) + "," + str(num_labeled_leaves))
    
