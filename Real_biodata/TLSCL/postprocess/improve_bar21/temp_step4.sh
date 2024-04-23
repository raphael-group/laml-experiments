selected_tree=place_outlier/augmented_tree_42_optimized_trees.nwk

# step 4: do final topology search (repeat for multiple trials)
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t $selected_tree -o Bar21_improved_final -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1 --topology_search --parallel
