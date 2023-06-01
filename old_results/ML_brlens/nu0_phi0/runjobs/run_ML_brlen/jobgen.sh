#! /bin/bash

d=/n/fs/ragr-research/projects/problin_experiments/ML_brlens/nu0_phi0

for x in $d/k*rep*; do
	echo `pwd`/runjob.sh $x 
done	
