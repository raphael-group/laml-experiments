from treeswift import *
from random import sample
from problin_libs.sequence_lib import read_sequences

n = 100

dedup_msa = "/n/fs/ragr-research/projects/problin_experiments/Real_biodata/test_kptracer/3724_NT_T1_character_matrix.dedup.csv"
#`dedup_msa = "3724_NT_T1_character_matrix.dedup.csv"
dedup_msa, site_names = read_sequences(dedup_msa, filetype="charMtrx", delimiter=',')

inputs = ["/n/fs/ragr-research/projects/problin_experiments/Real_biodata/data_kptracer/3724_NT_T1/fixed_nni_tree.nwk"]
# inputs = ["/n/fs/ragr-research/projects/problin_experiments/Real_biodata/data_kptracer/3724_NT_T1/fixed_nni_tree.nwk"]
# inputs = ["/n/fs/ragr-research/projects/problin/data/kptracer/3724_NT_T1/startle_tree.nwk"]
outdir = "/n/fs/ragr-research/projects/problin_experiments/Real_biodata/test_kptracer"

for indata in inputs:
    fname = indata.split('/')[-2]
    tree = read_tree_newick(indata)
    tree.suppress_unifurcations()
    
    select_set = set(dedup_msa.keys())
    tree_pruned = tree.extract_tree_with(select_set)

    select_set = sample([node.label for node in tree_pruned.traverse_leaves()],n)
    tree_pruned = tree_pruned.extract_tree_with(select_set)

    tree_pruned.resolve_polytomies() 
    tree_pruned.write_tree_newick(outdir + "/" + fname + ".suppressed_unifurcations.nopolytomy.dedup.rand" + str(n) + ".nwk")

