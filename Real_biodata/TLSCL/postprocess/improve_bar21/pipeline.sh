# step 1a: perform topology search independently on problematic progenitor groups
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t progenitor_6_starting.nwk -o progenitor_6_improved --topology_search --parallel -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1 --randomreps 15 
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t progenitor_9_starting.nwk -o progenitor_9_improved --topology_search --parallel -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1 --randomreps 15 

# step 1b (manual): remove all de-novo groups that have less than 10 extant cells and stitch the improved trees back to the full tree list
    # --> produce Bar21_improved_step1_trees.nwk and Bar21_outlier_clade.nwk

# step 2: optimize branch lengths of the tree list produced in step 1
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t Bar21_improved_step1_trees.nwk -o Bar21_improved_step2 -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1 --nInitials 1

# step 3: search for optimal placement of the outlier clades detected in step 1
# this evaluation/Barcode only has one outlier group
mkdir place_outlier
# step 3a: optimize params for all possible placements
python ../bruteforce_placement.py Bar21_improved_step2_trees.nwk Bar21_outlier_clade.nwk place_outlier/augmented_tree 
for tree in place_outlier/augmented_tree*nwk; do
    python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t $tree -o place_outlier/`basename $tree .nwk`_optimized -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1 --nInitials 1
done
# step 3b: select the placement that has the best llh
#selected_tree=`grep Negative-llh place_outlier/augmented_tree_*_optimized_params.txt | sed -e "s/(//g" -e "s/,.*)//g" | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"`
# although tree 1 has slightly higher likelihood, we choose tree 42 (the second best) instead because tree 1 implies an unidentified progenitor group with only 1 cell
selected_tree=place_outlier/augmented_tree_42_optimized_trees.nwk

# step 4: do final topology search (repeat for multiple trials)
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t $selected_tree -o Bar21_improved_final -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1 --topology_search --parallel

# step 5: select the best tree obtained from step 4, then collapse short branches and re-optimize numerical params
selected_tree=Bar21_improved_final_trees.nwk
python ../collapse_short_branches.py $selected_tree 0.009 `basename $selected_tree .nwk`_collapsed.nwk
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar21/Bar21_character_matrix.txt -t `basename $selected_tree .nwk`_collapsed.nwk -o Bar21_improved_final_with_polytomies -v -p ../../evaluation/Bar21/Bar21_priors.pickle --delimiter tab -m -1

# step 6: merge the final list of trees into a single tree of multiple progenitors
python ../merge_trees.py Bar21_improved_final_with_polytomies_trees.nwk ../Bar21_labels.csv Bar21_improved_final_with_polytomies_merged.nwk
