#!/bin/bash

ddir1="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/cass_data"
ddir2="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/test_cass/out_GSE146712_lg11_tree_hybrid"

samples="${ddir1}/sample_mapping.txt"

ml_tree="${ddir2}/results_ML_tree.nwk"
echo "ML Tree"
python eval_cass_tree.py $ml_tree $samples

mlp_tree="${ddir2}/results_MLP_tree.nwk"
echo "MLP Tree"
python eval_cass_tree.py $mlp_tree $samples

mp_tree="${ddir2}/results_MP_tree.nwk"
echo "MP Tree"
python eval_cass_tree.py $mp_tree $samples
