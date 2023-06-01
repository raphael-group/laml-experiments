#! /bin/bash

# cd ../../ML_brlens/nu0_phi0
problindir="/n/fs/ragr-research/projects/problin"
wdir="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/test_cass"
#ddir="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/cass_data/lg11"
#data_name="GSE146712_lg11_tree_hybrid"
ddir="/n/fs/ragr-research/projects/problin_experiments/Real_biodata/cass_data/lg11"
data_name="GSE146712_lg11_tree_hybrid"

odir="${wdir}/out_${data_name}"
mkdir -p $odir

msa="${ddir}/${data_name}.processed.chrmtx.txt"
tree="${ddir}/${data_name}.processed.topo.txt"
pt="${odir}/${data_name}.suppressed_unifurcations.nopolytomy.dedup.rand100.nwk"
pc="${odir}/${data_name}.chrmtrx.dedup.csv"

if [[ -f $pt && $pc ]]; then
	echo "$pt and $pc already exist."
else
	echo 'python ${problindir}/scripts/preproc_trees.py $msa $tree $odir 100 "tab"'
	python ${problindir}/scripts/preproc_trees.py $msa $tree $odir 100 "tab" ${data_name}

	echo "Check that $pt and $pc were produced."
fi

outfile="${odir}/results_MLP_brlen.txt"
outtree="${odir}/results_MLP_tree.nwk"
if [[ -f $outfile  && -f $outtree ]]; then
	echo "$outfile and $outtree already exist."
else
	echo "python tmp_mlp_brlen.py $pt $pc $outtree | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}"
	python tmp_mlp_brlen.py $pt $pc $outtree | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}
fi 

outfile="${odir}/results_MP_brlen.txt"
outtree="${odir}/results_MP_tree.nwk"
if [[ -f $outfile  && -f $outtree ]]; then
	echo "$outfile and $outtree already exist."
else
	echo "python tmp_mp_brlen.py $pt $pc $outtree | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}"
	python tmp_mp_brlen.py $pt $pc $outtree | sort | sed -e "s/^/$x /g" | sed -e "s/k//g" -e "s/_/ /g" > ${outfile}
fi

# q="${ddir}/${data_name}/${data_name}_priors.pkl"
outfile="${odir}/results_ML_brlen.txt"
outtree="${odir}/results_ML_tree.nwk"
if [[ -f $outfile  && -f $outtree ]]; then
	echo "$outfile and $outtree already exist."
else
	sbatch --job-name="ML_$data_name" --output="$odir/log_ML_$data_name" runjob.sh $pt $pc $outfile
	# python ${problindir}/optimize_brlen.py -t $pt -c $pc -p "uniform" --delimiter "comma" --nInitials 5 -m -1 -o ${outfile} 
	# test_ml.py $t $c "uniform" ${outfile}
fi
