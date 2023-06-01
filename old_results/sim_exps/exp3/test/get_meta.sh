#! /bin/bash

k=30

mkdir -p "results_k${k}"

problindir="/n/fs/ragr-research/projects/problin"
ddir="/n/fs/ragr-research/projects/problin_experiments/sim_exps/exp3/data"

runtime=true
likelihood=true
numem=true

if [  "$runtime" = true  ] ; then
    outfile="experiment_time.csv"
    echo "Datatype,Rep,NumCells,Time" > ${outfile}
    #echo "Datatype,Rep,NumCells,Time,NLLH" > ${outfile}
    datatype="nomissing"
    for n in "150" "200" "300" "500" "700" "1000" "1500" "2000" "3500"; do

        for rep in {0..9..1}; do
            # log_k30_nomissing_rep0_n1000     
            fname="logs/log_k${k}_${datatype}_rep${rep}_n${n}_nm_masterEM"
            t=$(tail -3 ${fname} | head -1 | awk '{ print $2 }')
            nllh=$(tail -5 ${fname} | head -1 | awk ' { print $3 }')
            echo "${datatype},${rep},${n},$t" >> ${outfile}
            #echo "${datatype},${rep},${n},$t,${nllh}" >> ${outfile}
                
        done
    done
fi

if [  "$likelihood" = true  ] ; then
    outfile="experiment_likelihood.csv"
    echo "Datatype,Rep,NumCells,NLLH" > ${outfile}
    datatype="nomissing"
    for n in "150" "200" "300" "500" "700" "1000" "1500" "2000" "3500"; do

        for rep in {0..9..1}; do
            # log_k30_nomissing_rep0_n1000     
            fname="logs/log_k${k}_${datatype}_rep${rep}_n${n}_nm_masterEM"
            nllh=$(tail -5 ${fname} | head -1 | awk ' { print $3 }')
            echo "${datatype},${rep},${n},${nllh}" >> ${outfile}
        done
    done
fi

if [  "$numem" = true  ] ; then
    outfile="experiment_numem.csv"
    echo "Datatype,Rep,NumCells,Initial,NumEmIter" > ${outfile}
    datatype="nomissing"
    for n in "150" "200" "300" "500" "700" "1000" "1500" "2000" "3500"; do

        for rep in {0..9..1}; do
            # log_k30_nomissing_rep0_n1000     
            fname="logs/log_k${k}_${datatype}_rep${rep}_n${n}_nm_masterEM"
            echo ${fname}
            grep "EM finished after" ${fname} | awk '{ print $4 }' > tmp.txt
            initial=0
            while read p ; do
                #echo ${initial}
                echo "${datatype},${rep},${n},${initial},${p}" >> ${outfile}
                initial=$((initial+1))
            done < tmp.txt
            rm tmp.txt
        done
    done
fi
