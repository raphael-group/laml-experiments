selected_tree=Bar11_improved_final_trees.nwk
python ../collapse_short_branches.py $selected_tree 0.009 `basename $selected_tree .nwk`_collapsed.nwk
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar11/Bar11_character_matrix.txt -t `basename $selected_tree .nwk`_collapsed.nwk -o Bar11_improved_final_with_polytomies -v -p ../../evaluation/Bar11/Bar11_priors.pickle --delimiter tab -m -1