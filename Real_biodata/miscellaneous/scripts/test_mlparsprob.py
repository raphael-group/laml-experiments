import os
import numpy as np
from scipy import optimize
import math
from math import log, exp
import sys
from problin_libs.ml_log import mlpars 
from problin_libs.sequence_lib import read_sequences
import dendropy

c = sys.argv[1]
Q = sys.argv[2]
T = sys.argv[3]

# ../data_kptracer/3724_NT_T1/3724_NT_T1_priors.pkl

print("[test_mlpars.py]")

D = read_sequences(c, filetype="charMtrx")
nwkt = dendropy.Tree.get(data=T, schema="newick", rooting="force-rooted")

f = open(Q, "rb")
Q = pickle.load(f)

outfile = "mlpars_output.txt"
try:
    os.makedirs(dirname)
except FileExistsError:
    pass

with open(outfile, "w") as fout:
    T, ll, b = mlpars(nwkt, Q, D, False)
    fout.write(str(ll) + "\n")
    fout.write(str(T) + "\n")
    fout.write(str(b) + "\n")



