
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
echo $selected_tree
