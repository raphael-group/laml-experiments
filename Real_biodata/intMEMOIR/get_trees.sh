#!/bin/bash

basedir=intmemoir_input_data
mkdir -p $basedir
for file in /n/fs/ragr-research/projects/problin_experiments/Real_biodata/spalin_intMemoir/processed_data/brlen_estimation/*/true_tree.nwk; do 
    orig_sample_dir=`dirname $file`
    sample_id=`basename "$(dirname $file)"`
    sample_dir=$basedir/$sample_id
    mkdir -p $sample_dir

    cp $orig_sample_dir/true_tree.nwk $sample_dir/true_tree.nwk
    cp $orig_sample_dir/characters.proc.csv $sample_dir/characters.proc.csv
    cp $orig_sample_dir/cass_hybrid_tree_resolved.newick $sample_dir/cass_hybrid_tree_resolved.newick
    cp $orig_sample_dir/EM_problin.nwk $sample_dir/EM_problin.nwk
    cp $orig_sample_dir/priors.csv $sample_dir/priors.csv
    cp $orig_sample_dir/priors.pkl $sample_dir/priors.pkl
    cp $orig_sample_dir/startlenni_tree_collapsed.newick $sample_dir/startlenni_tree_collapsed.newick

done
