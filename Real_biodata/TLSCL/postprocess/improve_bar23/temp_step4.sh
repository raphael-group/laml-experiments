selected_tree=place_outlier1/augmented_tree_68_optimized_trees.nwk
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t $selected_tree -o Bar23_improved_final -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --topology_search --parallel
