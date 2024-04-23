#! /bin/bash

for B in Bar*; do
    python ~/my_gits/LAML/run_laml.py -t $B/$B\_ilp_newick_noMutationlessEdges.txt -c $B/$B\_character_matrix.txt -p $B/$B\_priors.pickle --delimiter tab -m -1 -o $B/cassILP_brlen 
done
