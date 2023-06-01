#! /bin/bash

problindir="/n/fs/ragr-research/projects/problin"
ddir="/n/fs/ragr-research/projects/problin_experiments/sim_cass/sim_data"
wdir="/n/fs/ragr-research/projects/problin_experiments/sim_cass/test_data"

base_name="n150_m30"

#for dname in "nodropout" "nomissing"; do
# for dname in "bothmissing" "noheritable"; do
# for dname in "bothmissing" "nodropout" "noheritable" "nomissing"; do
dname="bothmissing"
	echo "dname"
	data_name="${base_name}_${dname}"
	echo "Data Name is ${data_name}"
	odir="${wdir}/out_${data_name}"

	true_tree="${ddir}/${base_name}_${dname}_bltree.newick"

	# resolve true tree
	#python ${problindir}/scripts/preproc_trees.py ${ddir}/${data_name}_character_matrix.csv ${ddir}/${data_name}_bltree.newick ${odir} "No Sampling" "comma" ${data_name}_truebl
	tt_proc="${odir}/${data_name}_truebl.suppressed_unifurcations.nopolytomy.dedup.nwk"

	out_brlen="${odir}/results_ML_brlen_all.txt"
	out_params="${odir}/results_ML_params_all.txt"
	gen="${odir}/results_ML_brlen_${dname}_flags"
	#bm="${odir}/results_ML_brlen_${dname}_flags_bothMissing.txt"
	#nd="${odir}/results_ML_brlen_${dname}_flags_noDropout.txt"
	#nh="${odir}/results_ML_brlen_${dname}_flags_noHeritable.txt"
	#nm="${odir}/results_ML_brlen_${dname}_flags_noMissing.txt"
	python compile_results.py --tt ${tt_proc} --pre ${gen} --out_brlen ${out_brlen} --out_param ${out_params} -nd -nm

#done

