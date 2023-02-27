#! /bin/bash

problindir="/n/fs/ragr-research/projects/problin"
datadirbase="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp3/data"
wdir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp3/test"

#d=0.1
k=30
#s=0.01
base_name="b${b}"

for n in "150" "200" "300" "500" "700" "1000" "1500" "2000" "3500"; do
#n=150
    for rep in {0..9..1}; do
#rep=0
        mkdir -p logs
        ddir="${datadirbase}/n${n}"
        base_name="k${k}"
        odir="${wdir}/out_n${n}"
        mkdir -p ${odir}

        t="${ddir}/cass_tree.nwk"
        #t="${ddir}/cass_tree_edit.nwk"
        p="${ddir}/${base_name}_prior_shared_rep${rep}.txt"

        # no missing data
        datatype="nomissing"
        echo "DATATYPE: ${datatype}"
        data_name="${datatype}_rep${rep}"

        out_name="${data_name}_n${n}_nm_masterEM"
        #out_name="${data_name}_n${n}_nm_noEM"

        c="${ddir}/${base_name}_charactermatrix_${data_name}.txt"
        outfile="${odir}/results_ML_${out_name}.txt"
        #outfile="results_ML_${out_name}.txt"
        
        if [[ -f ${outfile} ]]; then
            echo "${outfile} already exists."
        else
            #echo "sbatch --job-name=${out_name} --output=logs/log_${base_name}_${out_name} runjob2.sh ${c} ${t} ${p} ${outfile} ${odir}"
            #sbatch --job-name=${out_name} --output=logs/log_${base_name}_${out_name} runjob2.sh ${c} ${t} ${p} ${outfile} ${odir}
            #echo "sbatch --job-name=${out_name} --output=logs/log_${base_name}_${out_name} runjob.sh ${c} ${t} ${p} ${outfile} ${odir}"
            #sbatch --job-name=${out_name} --output=logs/log_${base_name}_${out_name} runjob.sh ${c} ${t} ${p} ${outfile} ${odir}
            echo "sbatch --job-name=${out_name} --output=logs/log_${base_name}_${out_name} runjob.sh ${c} ${t} ${p} ${outfile} "
            sbatch --job-name=${out_name} --output=logs/log_${base_name}_${out_name} runjob.sh ${c} ${t} ${p} ${outfile} 
        fi

    done
done

