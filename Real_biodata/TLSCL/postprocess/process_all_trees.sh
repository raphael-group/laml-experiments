#! /bin/bash

for tree in Bar*.nwk; do
    tag=`basename $tree _trees.nwk`   
    echo $tag 
    python process_one_tree.py $tree $tag\_labels.csv $tag\_split_trees.nwk > $tag\_split_trees.log 2>&1
done    
