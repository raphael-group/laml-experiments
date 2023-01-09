import pickle
import subprocess
import os
import numpy as np
from scipy import optimize
import math
from math import log, exp
import sys
from problin_libs.ml import wrapper_felsenstein
from problin_libs.ML_solver import ML_solver
from problin_libs.sequence_lib import read_sequences

# this file should be deprecated. use optimize_brlen.py instead.

treefile = sys.argv[1]
msa = sys.argv[2]
priorfile = sys.argv[3]
outfile = sys.argv[4]

with open(treefile, "r") as f:
    treeStr = f.read().strip()

msa, site_names = read_sequences(msa, filetype="charMtrx", delimiter=',')

final_msa = dict()
for cell in msa:
    s = msa[cell]
    final_msa[cell] = [c if c != -1 else "?" for c in s]
msa = final_msa

k = len(msa[next(iter(msa.keys()))])
if priorfile == "uniform":
    pass
else: 
    infile = open(priorfile, "rb")
    priors = pickle.load(infile)
    infile.close()
    Q = []
    for i in sorted(priors.keys()):
        q = {int(x):priors[i][x] for x in priors[i]}
        q[0] = 0
        Q.append(q)

fixed_phi, fixed_nu = 1e-10, 1e-10

mySolver = ML_solver(msa,Q,treeStr)
optimal_llh = mySolver.optimize(initials=1,fixed_phi=fixed_phi,fixed_nu=fixed_nu)
# optimal_llh = mySolver.optimize(initials=20,fixed_phi=fixed_phi,fixed_nu=fixed_nu)

tree = mySolver.params.tree
with open(outfile, "w+") as w:
    tree.root.h = 1
    for idx, node in enumerate(tree.traverse_preorder()): # GILLIAN CHANGED
        if not node.is_root():
            node.h = node.parent.h + 1
            if node.edge_length is not None:
                w.write(str(idx) + " " + str(node.h) + " " + str(node.edge_length) + "\n")
