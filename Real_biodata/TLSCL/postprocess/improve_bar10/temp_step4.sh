selected_tree=place_outlier4/augmented_tree_476_optimized_trees.nwk

# step 4: do final topology search (repeat for multiple trials)
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar10/Bar10_character_matrix.txt -t $selected_tree -o Bar10_improved_final_trial4 -v -p ../../evaluation/Bar10/Bar10_priors.pickle --delimiter tab -m -1 --topology_search --parallel
