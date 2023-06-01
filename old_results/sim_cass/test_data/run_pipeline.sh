#! /bin/bash

problindir="/n/fs/ragr-research/projects/problin"
ddir="/n/fs/ragr-research/projects/problin_experiments/sim_cass/sim_data"
wdir="/n/fs/ragr-research/projects/problin_experiments/sim_cass/test_data"

base_name="n150_m30"

mkdir -p logs
#dname="bothmissing"
for dname in "bothmissing" "noheritable"; do
# for dname in "bothmissing" "nodropout" "noheritable" "nomissing"; do

	echo "dname"
	data_name="${base_name}_${dname}"
	echo "Data Name is ${data_name}"
	odir="${wdir}/out_${data_name}"
	mkdir -p ${odir}

	# preprocess trees
	# take out polytomies
	# deduplicate
	# format character matrix

	# t="${wdir}/${data_name}.suppressed_unifurcations.nopolytomy.dedup.rand100.nwk"
	# c="${wdir}/${data_name}_character_matrix.dedup.csv"
	# q="${ddir}/${data_name}/${data_name}_priors.pkl"

	t="${ddir}/${data_name}_tree.newick"
	c="${ddir}/${data_name}_character_matrix.csv"

	nt="${odir}/${data_name}_tree.suppressed_unifurcations.nopolytomy.dedup.nwk"
	nc="${odir}/${data_name}_character_matrix.dedup.csv"

	if [[ -f ${nt} && -f ${nc} ]]; then

		echo "${nt} and ${nc} already exist."

	else
		# replace the missing data from -1 to ? (RESOLVED)
		echo "python ${problindir}/scripts/preproc_trees.py $c $t ${odir}"
		python ${problindir}/scripts/preproc_trees.py $c $t ${odir}

		echo "Check that ${nt} and ${nc} were created."
	fi

	p="${ddir}/${data_name}_mutation_prior.csv"
	# character, state, probability separated by spaces (RESOLVED)

	pre="${dname}_flags_noMissing"
	outfile="${odir}/results_ML_brlen_${pre}.txt"
	echo 'sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "--noSilence --noDropout"'
	sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "--noSilence --noDropout"
	
	#pre="${dname}_flags_noHeritable"
	pre="${dname}_flags_noDropout"
	outfile="${odir}/results_ML_brlen_${pre}.txt"
	echo 'sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "--noSilence"'
	sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "--noSilence"
	
	#pre="${dname}_flags_noDropout"
	pre="${dname}_flags_noHeritable"
	outfile="${odir}/results_ML_brlen_${pre}.txt"
	echo 'sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "--noDropout"'
	sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "--noDropout"
	
	#pre="${dname}_flags_bothMissing"
	#outfile="${odir}/results_ML_brlen_${pre}.txt"
	#echo 'sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} "" '
	#sbatch --job-name="${pre}" --output="logs/log_${pre}" runjob.sh ${nc} ${nt} ${p} ${outfile} ""

done

