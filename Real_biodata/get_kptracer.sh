#!/bin/bash
outdir="data_kptracer"
mkdir -p ${outdir} 

kpdata_cmatrix="/n/fs/ragr-research/projects/lineage-tracing/kp-data/cassiopeia/*_character_matrix.txt"
kpdata_priors="/n/fs/ragr-research/projects/lineage-tracing/kp-data/cassiopeia/*_priors.pkl"
cass_trees="/n/fs/ragr-research/users/schmidth/KPTracer-Data/trees/*_tree.nwk"
nj_trees="/n/fs/ragr-research/users/schmidth/KPTracer-Data/trees/neighbor_joining/*.tree"
startle_trees="/n/fs/ragr-research/projects/lineage-tracing-nni/data/kp-tracer" # there's only two
for FILE in $kpdata_cmatrix; do
# for FILE in $nj_trees; do
	echo $FILE
	function split {

		DIR=$(/bin/dirname "$1")
		BASE=$(/bin/basename "$1")
		EXT=$(echo "$BASE" | /usr/bin/awk -F. 'NF>1 {print $NF}')
		NAME=${BASE%.$EXT}
		# echo directory=$DIR filename=$NAME extension=$EXT
		splitname=$(echo "$NAME" | /usr/bin/awk -F"_" '{ print $1"_"$2"_"$3 }' )
		#echo $splitname
		echo $splitname
	}
	
	expname=$(split $FILE)
	mkdir -p ${outdir}/${expname}
	cp $FILE ${outdir}/${expname}/.
	#cp $FILE ${outdir}/${expname}/nj_tree.nwk
	
	
done
