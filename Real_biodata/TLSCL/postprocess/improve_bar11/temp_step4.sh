selected_tree=place_outlier9/augmented_tree_260_optimized_trees.nwk
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar11/Bar11_character_matrix.txt -t $selected_tree -o Bar11_improved_final -v -p ../../evaluation/Bar11/Bar11_priors.pickle --delimiter tab -m -1 --topology_search --parallel
