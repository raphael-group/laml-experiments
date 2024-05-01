# step 1a: perform topology search independently on problematic progenitor groups
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t progenitor_10_starting.nwk -o progenitor_10_improved --topology_search --parallel -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --randomreps 15 
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t progenitor_11_starting.nwk -o progenitor_11_improved --topology_search --parallel -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --randomreps 15 
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t progenitor_16_starting.nwk -o progenitor_16_improved --topology_search --parallel -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --randomreps 15 

# step 1b (manual): remove all de-novo groups that have less than 23 extant cells and stitch the improved trees back to the full tree list
    # --> produce Bar23_improved_step1_trees.nwk and Bar23_outlier_clades.nwk

# step 2: optimize branch lengths of the tree list produced in step 1
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t Bar23_improved_step1_trees.nwk -o Bar23_improved_step2 -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --nInitials 1

# step 3: search for optimal placement of the outlier clades detected in step 1
i=1
selected_tree=Bar23_improved_step2_trees.nwk
while read tree; do
    temp=`mktemp`
    echo $tree > $temp
    mkdir place_outlier$i
    python ../bruteforce_placement.py $selected_tree $temp place_outlier$i/augmented_tree
    for tree in place_outlier$i/augmented_tree*nwk; do
        python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t $tree -o place_outlier$i/`basename $tree .nwk`_optimized -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --nInitials 1
    done
    selected_tree=`grep Negative-llh place_outlier$i/augmented_tree_*_optimized_params.txt | sed -e "s/(//g" -e "s/,.*)//g" | sort -nk2,2 | head -n1 | sed -e "s/_params.*/_trees.nwk/g"`
    rm $temp
    i=$((i+1))
done < Bar23_outlier_clades.nwk 

# step 4: do final topology search (repeat for multiple trials)
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t $selected_tree -o Bar23_improved_final -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1 --topology_search --parallel

# step 5: select the best tree obtained from step 4, then collapse short branches and re-optimize numerical params
selected_tree=Bar23_improved_final_trees.nwk
python ../collapse_short_branches.py $selected_tree 0.009 `basename $selected_tree .nwk`_collapsed.nwk
python ~/my_gits/LAML/run_laml.py -c ../../evaluation/Bar23/Bar23_character_matrix.txt -t `basename $selected_tree .nwk`_collapsed.nwk -o Bar23_improved_final_with_polytomies -v -p ../../evaluation/Bar23/Bar23_priors.pickle --delimiter tab -m -1

# step 6: merge the final list of trees into a single tree of multiple progenitors
python ../merge_trees.py Bar23_improved_final_with_polytomies_trees.nwk ../Bar23_labels.csv Bar23_improved_final_with_polytomies_merged.nwk
