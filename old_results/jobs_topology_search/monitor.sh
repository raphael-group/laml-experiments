#!/bin/bash

echo "ML (Neither) Prob Results"
for k in 20 30 40 50 100 200 300 400 500 5000
do
	num=$(ls mlnone_results_k$k/ | wc -l)
	#num=$(ls mlpars_results_k$k/ | wc -l)
	echo "k: $k, num done: $num"
	#python find_best_topologies.py $k 1000
	#python find_best_mlpars_topologies.py $k 1000
done
:'
echo "ML Parsimony Hamming Results"
for k in 20 30 40 50 100 200 300 400 500 5000
do
	num=$(ls mlparsham_results_k$k/ | wc -l)
	#num=$(ls mlpars_results_k$k/ | wc -l)
	echo "k: $k, num done: $num"
	#python find_best_topologies.py $k 1000
	#python find_best_mlpars_topologies.py $k 1000
done

echo "ML Parsimony Prob Results"
for k in 20 30 40 50 100 200 300 400 500 5000
do
	num=$(ls mlparsprob_results_k$k/ | wc -l)
	#num=$(ls mlpars_results_k$k/ | wc -l)
	echo "k: $k, num done: $num"
	#python find_best_topologies.py $k 1000
	#python find_best_mlpars_topologies.py $k 1000
done
'
