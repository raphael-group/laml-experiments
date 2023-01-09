import subprocess
import os
import numpy as np
from scipy import optimize
import math
from math import log, exp
import sys
from problin_libs.ml import wrapper_felsenstein
#from problin_libs.compare_two_trees import compare_trees
from problin_libs.sequence_lib import read_sequences

true_tree = ''

# enumerate all fifteen topologies for 4 leaves
topologies = ["((a,b),(c,d));","((a,c),(b,d));","((a,d),(b,c));",
             "(a,(b,(c,d)));","(a,(c,(b,d)));","(a,(d,(b,c)));",
             "(b,(a,(c,d)));","(b,(c,(a,d)));","(b,(d,(a,c)));",
             "(c,(a,(b,d)));","(c,(b,(a,d)));","(c,(d,(a,b)));",
             "(d,(a,(b,c)));","(d,(b,(a,c)));","(d,(c,(a,b)));"]

true_topology = '((a,b),(c,d));',

m = 10

idx = int(sys.argv[1])
k = int(sys.argv[2])
rep = int(sys.argv[3])

prior_file = "prior_files/prior_k" + str(k) + ".txt"

Q = []
for i in range(k):
    q = {j+1:1/m for j in range(m)}
    q[0] = 0
    Q.append(q)
topology = topologies[idx]

dirname = "mlnone_results_k" + str(k) + "/rep" + str(rep)
try:
    os.makedirs(dirname)
except FileExistsError:
    pass
cmtx = "../MP_inconsistent/seqs_m10_k" + str(k) + ".txt"
outfile=dirname + "/topo" + str(idx) + ".txt"

subprocess.call(["./test_ml_topo.sh", cmtx, topology, outfile, str(rep), prior_file])

