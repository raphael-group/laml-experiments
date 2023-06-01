#! /bin/bash

problindir="/n/fs/ragr-research/projects/problin"
ddir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp2/data"
wdir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp2/test2"

k=30
outfile="${wdir}/experiment_bl_results.csv"
echo "Rep,DataType,Flags,TrueBrLen,EstBrLen" > ${outfile}

for datatype in "d0.1"; do
#for datatype in "nomissing" "d0.1"; do
    base_name="k${k}_${datatype}"
    for rep in {0..9..1}; do
        data_name="k${k}_${datatype}_rep${rep}"
        blfile="results_k${k}/results_ML_${data_name}_bl.txt"
        echo ${blfile}
        if [[ -f ${blfile} ]]; then
            sed '1d' ${blfile} >> ${outfile}
        fi
    done
done

outfile="${wdir}/experiment_param_results.csv"
echo "Rep,Datatype,Flags,NLL,EstDropout,EstSilencing" > ${outfile}

for datatype in "d0.1"; do
#for datatype in "nomissing" "d0.1"; do
    base_name="k${k}_${datatype}"
    for rep in {0..9..1}; do
        data_name="k${k}_${datatype}_rep${rep}"
        paramfile="results_k${k}/results_ML_${data_name}_params.txt"
        echo ${paramfile}
        if [[ -f ${paramfile} ]]; then
            sed '1d' ${paramfile} >> ${outfile}
        fi
    done
done
