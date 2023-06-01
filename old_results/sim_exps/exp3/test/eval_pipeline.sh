#! /bin/bash

k=30

mkdir -p "results_k${k}"

problindir="/n/fs/ragr-research/projects/problin"
ddir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp2/data"
wdir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp2/test2/out_k$k" 

for datatype in "d0.1" ; do 
#for datatype in "nomissing" "d0.1" ; do 
    base_name="k${k}"
    for rep in {0..9..1}; do
        data_name="k${k}_${datatype}_rep${rep}"

        t="${ddir}/cass_tree_edit.nwk"
        pre="${wdir}/results_ML_${datatype}_rep${rep}_flags"
        p="${ddir}/${base_name}_prior_shared_rep${rep}.txt"

        # character, state, probability separated by spaces (RESOLVED)
        
        outfile="results_k${k}/results_ML_${data_name}_bl.txt"
        paramfile="results_k${k}/results_ML_${data_name}_params.txt"
        if [[ -f ${paramfile} ]]; then
            echo "$paramfile already exists."
        else 
            python ${problindir}/problin_libs/compile_results.py --tt ${t} -ns --pre ${pre} --out_param ${paramfile} --out_bl ${outfile} --rep ${rep} --datatype ${datatype}
        fi
    done
done
