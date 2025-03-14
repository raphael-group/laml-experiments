#! /bin/bash
# compute triplet distance to a cluster tree (only count resolved triplets)

tag=$1 # e.g. ilp_newick_noMutationlessEdges.txt, startlenni_tree_collapsed.newick 

for B in Bar*; do
    # step 1: prune leaves with missing labels from the Cassiopeia tree
    nw_prune $B/$B\_$tag `grep "?" $B/$B\_labels.csv | awk '{print $1;}'` > $B/$B\_$tag\_noMissing.txt
    # step 2: create the cluster tree, prune it to the same leafset as the query tree, and compute its number of resolved triplets
    python create_cluster_tree.py $B/$B\_labels.csv $B/$B\_clusterTree.nwk
    nw_prune -v $B/$B\_clusterTree.nwk `nw_labels -I $B/$B\_$tag\_noMissing.txt` > $B/$B\_clusterTree_pruned.nwk
    #sed -i "" -e "s/\[&R\] //g" $B/$B\_clusterTree_pruned.nwk
    nRT=`~/Packages_N_Libraries/tqDist-1.0.2/bin/triplet_dist -v $B/$B\_clusterTree_pruned.nwk $B/$B\_clusterTree_pruned.nwk | awk '{print $5;}'`
    # step 3: compute the resolved triplet distance of Cassiopeia to the cluster tree, normalize by the number of resolved triplets in the cluster tree
    echo $B `~/Packages_N_Libraries/tqDist-1.0.2/bin/triplet_dist -v $B/$B\_clusterTree_pruned.nwk $B/$B\_$tag\_noMissing.txt | awk '{print $5;}' | numlist -div$nRT | numlist -sub1 | numlist -neg`
done
