Simulate data to match the statistics of the tlscl data. More info here:
https://docs.google.com/spreadsheets/d/1Z7eT4IaLlardcw2S_MjRaFDrAG9tOGQWCdI_IHn_x7g

Simulation procedure:
1. Simulate a tree with 1024 leaves (10 cell divisions). Rescale tree depth to 1
2. Simulate sequences down the tree (tree depth = 1 => ~36 % zeros at leaves) with 25 % missing entries. 
The 2 types of missing data distributed as one of the following 5 scenrios:
	* Scenario 1 (tag s0d100): 100 % dropout, 0 % silencing => phi = 0.25, nu = 0
	* Scenario 2 (tag s100d0): 0 % dropout, 100 % silencing => phi = 0, nu = 0.288
	* Scenario 3 (tag s25d75): 75 % dropout, 25 % silencing => phi = 0.2, nu = 0.065
	* Scenario 4 (tag s50d50): 50 % dropout, 50 % silencing => phi = 0.143, nu = 0.134
	* Scenario 5 (tag s75d25): 25 % dropout, 75 % silencing => phi = 0.077, nu = 0.208
Simulate 10 replicates for each scenario
3. Subsample 250 cells. Repeat 5 times.

*Check simulation 
- Data size: 
	+ *_all_sequences.txt: 2048*30 matrix + 1 newick tree
	+ *_stats.txt: 2048 lines
	+ *_character_matrix.csv: 1024*30 matrix

*Check sampling:
- asserts sampled subtree contains 2n - 1 nodes
- num lines in sampled *_character_matrix.csv contains n = 251 lines
- check that the sampled leaves are different each iteration

Total number of replicates: 5 * 10 * 5 = 250

### EXPERIMENT DETAILS:
Problin_v3.0p
Ran with commit hash: `da3eb275bbea7364113dfbe930897d0c6000ba9e` on branch Toposearch_parallel originally.
This branch will be merged into master, and tagged. 

The goal of this experiment was to explore several tasks:
- comparison between ultrametric and no ultrametric constraint
- compare runtime and number of EM iterations as number of cells increase
- compare parameter estimation on a given estimated topology under several different model conditions
- compare topology estimation given observed data under several different model conditions

To achieve this, we performed comparisons between startle-nni (run for 250 iterations), cass-greedy, problin, and the true topology as a baseline. We used several metrics: rfdistance, weighted parsimony score (using startle to calculate), nllh (translated to llh for plots) estimated by problin, branch length error, nu and phi estimated missing data parameters. 

Result files used to make the simulated data figures were collected in the stats/ folder. Generally, all data files can be found in the respective model condition folder, named as follows:

s50d50p01_sub250_r01
- silencing 50%
- dropout 50%
- prior file 01 (of 10)
- subsampled 250 leaves
- replicate 01 (of 10)

Note that the rfdistance and weighted parsimony score statistics are in runjobs/est_params/logs/*.

Slurm scripts can be found in the runjobs/ folder. This is split by the task, and should be self-explanatory.
- problin_runtime
- run_stats

- problin_trueLLH: calculating the log likelihood of the true simulated tree.
- problin_trueTree: calculating parameters given the true tree topology. 
- problin_toposearch: performing tree topology search with problin.
- problin_startle: estimating a startle-nni tree topology.
- problin_cass: estimating a cass greedy (cassg) tree topology. there are also scripts to run cass hybrid (cassh), but these results are incomplete.
- est_params: estimating parameters given a tree topology (e.g. startle or cassgreedy).

Date run: 05-11-2023

sim_tlscl/est_trees_sub250.zip -- contains problin estimated trees for all model conditions for subsample size 250
sim_tlscl/raw_data.zip -- all pre-sampling data generated, includes model tree 
sim_tlscl/raw_data_largesamples.zip -- all samples larger than 250 for model condition s50d50
sim_tlscl/raw_data_sub250.zip -- character matrix, tree.nwk, all_sequences for all model conditions of subsample size 250
sim_tlscl/scripts.zip -- all simulation scripts and stats scripts in the first directory

