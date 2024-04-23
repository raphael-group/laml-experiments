#! /bin/bash
# context: the bar10 LAML tree was inferred on an earlier version of the TLSCL data
# the character matrix of bar10 in the published TLSCL has slightly fewer number of cells
# so we need to filter out those cells in order to run the postprocessing step to improve the LAML tree

awk '{print $3;}' Bar10_split_trees.nwk | nw_prune -v - `tail -n+2 ../evaluation/Bar10/Bar10_character_matrix.txt | awk '{print $1;}'` > temp
paste Bar10_split_trees.nwk temp | awk '{print $1,$4;}' > Bar10_split_trees_pruned.nwk
