# step 5: select the best tree obtained from step 4, then collapse short branches and re-optimize numerical params
selected_tree=Bar23_improved_final_trees.nwk
python ../collapse_short_branches.py $selected_tree 0.009 `basename $selected_tree .nwk`_collapsed.nwk
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t `basename $selected_tree .nwk`_collapsed.nwk -o Bar23_improved_final_with_polytomies -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1

# step 6: merge the final list of trees into a single tree of multiple progenitors
python ../merge_trees.py Bar23_improved_final_with_polytomies_trees.nwk ../Bar23_labels.csv Bar23_improved_final_with_polytomies_merged.nwk
