#!/bin/bash
#SBATCH --job-name=ML_brlen 	 # create a short name for your job
#SBATCH --output=ML_brlen.log	 # stdout file
#SBATCH --nodes=1                # node count
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --time=48:00:00          # total run time limit (HH:MM:SS)
#SBATCH --array=1-100%100

linevar=`sed $SLURM_ARRAY_TASK_ID'q;d' tasks`
eval $linevar
