# step 1a: perform topology search independently on problematic progenitor groups
python ~/my_gits/LAML/run_laml.py -c ../../bar24/Bar24_character_matrix.txt -t progenitor_1_starting.nwk -o progenitor_1_improved --topology_search --parallel -v -p ../../bar24/Bar24_priors.pickle --delimiter tab -m -1 --randomreps 15 

# step 1b (manual): remove all de-novo groups that have less than 10 extant cells and stitch the improved trees back to the full tree list
    # --> produce Bar24_improved_step1_trees.nwk, Bar24_improved_step1_progenitor_list.txt, and Bar24_outlier_clades.nwk

# step 2: optimize branch lengths of the tree list produced in step 1
python ~/my_gits/LAML/run_laml.py -c ../../bar24/Bar24_character_matrix.txt -t Bar24_improved_step1_trees.nwk -o Bar24_improved_step2 -v -p ../../bar24/Bar24_priors.pickle --delimiter tab -m -1 --nInitials 1

# step 3: search for optimal placement of the outlier clades detected in step 1
# step 3_1: place the first outlier group
mkdir place_outlier_1
# step 3_1a: optimize params for all possible placements
python ../bruteforce_placement.py Bar24_improved_step2_trees.nwk Bar24_outlier_clade1.nwk place_outlier_1/augmented_tree 
for tree in place_outlier_1/augmented_tree*nwk; do
    python ~/my_gits/LAML/run_laml.py -c ../../bar24/Bar24_character_matrix.txt -t $tree -o place_outlier_1/`basename $tree .nwk`_optimized -v -p ../../bar24/Bar24_priors.pickle --delimiter tab -m -1 --nInitials 1
done
# step 3_1b: select the placement that has the best llh
selected_tree=`grep Negative-llh place_outlier_1/augmented_tree_*_optimized_params.txt | sed -e "s/(//g" -e "s/,.*)//g" | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"`
# step 3_2: place the second outlier group
mkdir place_outlier_2
# step 3_2a: optimize params for all possible placements
python ../bruteforce_placement.py $selected_tree Bar24_outlier_clade2.nwk place_outlier_2/augmented_tree
for tree in place_outlier_2/augmented_tree*nwk; do
    python ~/my_gits/LAML/run_laml.py -c ../../bar24/Bar24_character_matrix.txt -t $tree -o place_outlier_2/`basename $tree .nwk`_optimized -v -p ../../bar24/Bar24_priors.pickle --delimiter tab -m -1 --nInitials 1
done
# step 3_2b: select the placement that has the best llh
selected_tree=`grep Negative-llh place_outlier_2/augmented_tree_*_optimized_params.txt | sed -e "s/(//g" -e "s/,.*)//g" | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"`

# step 4: do final topology search (repeat for multiple trials)
python ~/my_gits/LAML/run_laml.py -c ../../bar24/Bar24_character_matrix.txt -t $selected_tree -o Bar24_improved_final -v -p ../../bar24/Bar24_priors.pickle --delimiter tab -m -1 --topology_search --parallel

# step 5: select the best tree obtained from step 4, then collapse short branches and re-optimize numerical params
selected_tree=`grep Negative-llh Bar24_improved_final*_params.txt | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"
python ../collapse_short_branches.py $selected_tree 0.009 `basename $selected_tree .nwk`_collapsed.nwk
python ~/my_gits/LAML/run_laml.py -c ../../bar24/Bar24_character_matrix.txt -t `basename $selected_tree .nwk`_collapsed.nwk -o Bar24_improved_final_with_polytomies -v -p ../../bar24/Bar24_priors.pickle --delimiter tab -m -1

# step 6: merge the final list of trees into a single tree of multiple progenitors
python ../merge_trees.py Bar24_improved_final_with_polytomies_trees.nwk Bar24_improved_step1_progenitor_list.txt Bar24_improved_final_with_polytomies_merged.nwk
