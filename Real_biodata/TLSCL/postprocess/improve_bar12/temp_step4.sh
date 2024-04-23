selected_tree=place_outlier/augmented_tree_312_optimized_trees.nwk
python ~/my_gits/LAML/run_laml.py -c ../../bar12/Bar12_character_matrix.txt -t $selected_tree -o Bar12_improved_final -v -p ../../bar12/Bar12_priors.pickle --delimiter tab -m -1 --topology_search --parallel
