#!/bin/bash

k=30
sub="sub30"
cond="s50d50"
for p in $(seq -f "%02g" 1 10) ; do

    for r in $(seq -f "%02g" 1 5); do

        sample="k${k}${cond}p${p}_${sub}_r${r}"
        java -jar tidetree/bin/tidetree.jar data_set4/${sample}_sample20.xml #2>&1 data_set4/${sample}.log
    done
done
#for f in /Users/gc3045/laml_experiments/rebuttal/data_set4/k30s50d50p*/
#python create_input_xml.py k30s50d50p01_sub30_r01 data_set4/k30s50d50p01_sub30_r01/character_matrix_cass.csv data_set4/prior_k30_r01.csv data_set4/k30s50d50p01_sub30_r01.xml
