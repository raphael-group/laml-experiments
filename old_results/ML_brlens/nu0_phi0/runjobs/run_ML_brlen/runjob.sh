#! /bin/bash

x=$1 # the directory
k=`basename $x | sed -e "s/_.*//g"`

python ~/my_gits/problin/optimize_brlen.py -c $x/characters.txt -t $x/../../model_tree.nwk -o $x/ML_output.txt --nInitials 20 --delimiter comma --noSilence --noDropout -p $x/../priors_$k\.txt --solver EM
