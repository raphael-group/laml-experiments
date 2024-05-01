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
