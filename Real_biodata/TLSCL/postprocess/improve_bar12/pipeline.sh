# step 1a: perform topology search independently on problematic progenitor groups
# according to ../Bar12_split_trees.log, there is no problematic progenitor groups --> skip 1a

# step 1b (manual): remove all de-novo groups that have less than 10 extant cells and stitch the improved trees back to the full tree list
    # --> produce Bar12_improved_step1_trees.nwk, Bar12_improved_step1_progenitor_list.txt, and Bar12_outlier_clade.nwk

# step 2: optimize branch lengths of the tree list produced in step 1
python ~/my_gits/LAML/run_laml.py -c ../../bar12/Bar12_character_matrix.txt -t Bar12_improved_step1_trees.nwk -o Bar12_improved_step2 -v -p ../../bar12/Bar12_priors.pickle --delimiter tab -m -1 --nInitials 1

# step 3: search for optimal placement of the outlier clades detected in step 1
# this barcode only has one outlier group
mkdir place_outlier
# step 3a: optimize params for all possible placements
python ../bruteforce_placement.py Bar12_improved_step2_trees.nwk Bar12_outlier_clade.nwk place_outlier/augmented_tree 
for tree in place_outlier/augmented_tree*nwk; do
    python ~/my_gits/LAML/run_laml.py -c ../../bar12/Bar12_character_matrix.txt -t $tree -o place_outlier/`basename $tree .nwk`_optimized -v -p ../../bar12/Bar12_priors.pickle --delimiter tab -m -1 --nInitials 1
done
# step 3b: select the placement that has the best llh
selected_tree=`grep Negative-llh place_outlier/augmented_tree_*_optimized_params.txt | sed -e "s/(//g" -e "s/,.*)//g" | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"`

# step 4: do final topology search (repeat for multiple trials)
python ~/my_gits/LAML/run_laml.py -c ../../bar12/Bar12_character_matrix.txt -t $selected_tree -o Bar12_improved_final -v -p ../../bar12/Bar12_priors.pickle --delimiter tab -m -1 --topology_search --parallel

# step 5: select the best tree obtained from step 4, then collapse short branches and re-optimize numerical params
#selected_tree=`grep Negative-llh Bar12_improved_final*_params.txt | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"`
selected_tree=Bar12_improved_final_trees.nwk
python ../collapse_short_branches.py $selected_tree 0.009 `basename $selected_tree .nwk`_collapsed.nwk
python ~/my_gits/LAML/run_laml.py -c ../../bar12/Bar12_character_matrix.txt -t `basename $selected_tree .nwk`_collapsed.nwk -o Bar12_improved_final_with_polytomies -v -p ../../bar12/Bar12_priors.pickle --delimiter tab -m -1

# step 6: merge the final list of trees into a single tree of multiple progenitors
python ../merge_trees.py Bar12_improved_final_with_polytomies_trees.nwk Bar12_improved_step1_progenitor_list.txt Bar12_improved_final_with_polytomies_merged.nwk
