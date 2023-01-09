#! /bin/bash

# cd ../../ML_brlens/nu0_phi0

ddir="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/data_kptracer"
wdir="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/test_kptracer"


data_name="3724_NT_All"
#data_name="3724_NT_T1"

odir="${wdir}/out_${data_name}"

t="${wdir}/${data_name}.suppressed_unifurcations.nopolytomy.dedup.rand100.nwk"
c="${wdir}/${data_name}_character_matrix.dedup.csv"

outfile="${odir}/results_MLP_brlen.txt"
echo "python tmp_mlp_brlen.py $t $c | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}"
python tmp_mlp_brlen.py $t $c | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}

outfile="${odir}/results_MP_brlen.txt"
echo "python tmp_mp_brlen.py $t $c | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}"
python tmp_mp_brlen.py $t $c | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}

q="${ddir}/${data_name}/${data_name}_priors.pkl"
outfile="${odir}/results_ML_brlen.txt"
python test_ml.py $t $c $q ${outfile}
