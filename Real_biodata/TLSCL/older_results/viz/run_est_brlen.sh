#!/bin/bash
#

for f in /Users/gc3045/scmail_v1/sc-mail-experiments/Real_biodata/TLSCL/bar*/Bar*stitched_tree.nwk ; do
    dirpath=$(dirname $f)
    name=$(basename $f)
    barcode_id=${name%%_*}
    echo $barcode_id

    if [ ${barcode_id} == "Bar12" ]; then
    #if [ ${barcode_id} != "Bar10" ]; then
        #tfile="${dirpath}/${barcode_id}_stitched_tree.nwk"
        tfile="${dirpath}/${barcode_id}_problin_cass.nwk"
        msa="${dirpath}/${barcode_id}_character_matrix.txt"
        priors="${dirpath}/${barcode_id}_priors.pickle"
        #priors="${dirpath}/${barcode_id}_priors.csv"

        #echo "python /Users/gc3045/scmail_v1/laml/run_laml.py -t $tfile -c $msa -p $priors --delimiter 'tab' -m '-1' -o "${barcode_id}""
        #python /Users/gc3045/scmail_v1/laml/run_laml.py -t $tfile -c $msa -p $priors --delimiter 'tab' -m '-1' -o "${barcode_id}"
        
        python /Users/gc3045/scmail_v1/laml/run_laml.py -t $tfile -c $msa -p $priors --delimiter 'tab' -m '-1' -o "${barcode_id}_cass"
    fi
done
#run_laml -t 
