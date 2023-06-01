#!/bin/bash
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=2G         # memory per cpu-core (4G is default)
#SBATCH --time=10:00:00          # total run time limit (HH:MM:SS)

pt=$1
pc=$2
outfile=$3

problindir="/n/fs/ragr-research/projects/problin"
echo "python ${problindir}/optimize_brlen.py -t $pt -c $pc -p "uniform" --delimiter "comma" --nInitials 5 -m -1 -o ${outfile} "
python ${problindir}/optimize_brlen.py -t $pt -c $pc -p "uniform" --delimiter "comma" --nInitials 5 -m -1 -o ${outfile} 
