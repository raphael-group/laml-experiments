#! /bin/bash

problindir="/n/fs/ragr-research/projects/problin"
ddir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp2/data"
wdir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp2/test"

k=30
blfile="${wdir}/experiment_bl_results.csv"
paramfile="${wdir}/experiment_param_results.csv"

out_pre="out_pngs/exp2_k30"
python ${problindir}/problin_libs/plot_results.py --blfile ${blfile} --paramfile ${paramfile} --out_pre ${out_pre}

