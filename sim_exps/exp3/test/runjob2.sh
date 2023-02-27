#!/bin/bash
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=2G         # memory per cpu-core (4G is default)
#SBATCH --time=168:00:00          # total run time limit (HH:MM:SS)

c=$1
t=$2
p=$3
outfile=$4
odir=$5

problindir="/n/fs/ragr-research/projects/problin"

echo "time python ${problindir}/optimize_brlen.py -c $c -t $t -o ${outfile} --nInitials 20 --delimiter comma -p $p -m ? --verbose --noSilence --noDropout --outputdir ${odir}"
time python ${problindir}/optimize_brlen.py -c $c -t $t -o ${outfile} --nInitials 20 --delimiter comma -p $p -m ? --verbose --noSilence --noDropout --outputdir ${odir}
#time python ${problindir}/optimize_brlen.py -c $c -t $t -o ${outfile} --nInitials 20 --delimiter comma --noSilence --noDropout -p $p -m ? --solver EM #--verbose True

