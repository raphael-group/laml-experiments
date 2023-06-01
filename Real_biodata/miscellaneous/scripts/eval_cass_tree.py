import sys
from treeswift import * 

tree = sys.argv[1]
samples = sys.argv[2]

T = read_tree_newick(tree)
sample_dict = dict()
with open(samples, "r") as r:
    lines = r.readlines()
    for line in lines[1:]:
        cellBC, sample = line.split()
        if cellBC in sample_dict:
            if sample != sample_dict[cellBC]:
                print("Problem:", cellBC, "has", sample_dict[cellBC], "and", sample)
        else:
            sample_dict[cellBC] = sample

# get all the leaves from the tree
leaves_in_tree = dict()
sample_to_leaves = dict()
for leaf in T.traverse_leaves():
    l = leaf.get_label()
    if l  not in sample_dict:
        print("Problem:", l, "not in sample_dict")
    sample = sample_dict[l]
    # find the sample assignments for each leaf
    leaves_in_tree[leaf] = sample
    if sample not in sample_to_leaves:
        sample_to_leaves[sample] = []
    sample_to_leaves[sample].append(l)

# print(sample_to_leaves)

# find the LCA for a sample assignment's leaves in the tree
all_leaves = set()
for sample in sample_to_leaves:
    try:
        mrca = T.mrca(set(sample_to_leaves[sample]))
    except TypeError:
        raise
    except RuntimeError:
        raise
    
    # print("MRCA:", type(mrca))
    h = 1
    wh = 0
    cn = mrca
    while not cn.is_root():
        wh += cn.get_edge_length()
        cn = cn.get_parent()
        h += 1
    # report the LCA for each sample assignment in this tree
    print("Sample:", sample, "Height:", h, "Weighted Height:", wh, "# CellBC in Sample:", len(sample_to_leaves[sample]))
    all_leaves.update(set(sample_to_leaves[sample]))

# print total tree height
print("Total tree height:", T.height(weighted=False))
print("Total (weighted) tree height:", T.height(weighted=True))

#print("MRCA topo:")
#print(T.extract_tree_without(all_leaves))
