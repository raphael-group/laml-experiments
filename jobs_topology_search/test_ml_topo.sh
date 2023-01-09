#!/bin/bash
#SBATCH --job-name=test_topo 	 # create a short name for your job
#SBATCH --output=./slurm_ml/slurm-%A.%a.out # stdout file
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=2G         # memory per cpu-core (4G is default)
#SBATCH --time=10:00:00          # total run time limit (HH:MM:SS)

mkdir -p "slurm_ml"

echo "python run_ml_topo.sh -c $1 -t $2 -p $5 -o $3 -r $4 --noDropout --noSilence" 
python run_ml_topo.sh -c $1 -t $2 -p $5 -o $3 -r $4 --noDropout --noSilence
