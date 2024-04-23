#! /usr/bin/env python

import jenkspy
from sys import argv
from math import log,exp
import numpy as np
from sklearn.mixture import GaussianMixture

input_file = argv[1]
take_log = bool(argv[2])

with open(input_file,'r') as fin:
    data = [float(x) for x in fin.readlines()]
    if take_log:
        data = [log(x) for x in data if x>0]

data.sort()
data = np.array([[x] for x in data])
gm = GaussianMixture(n_components=2, random_state=0).fit(data)
c = gm.predict(data)

min_0 = float("inf")
max_0 = -float("inf")
min_1 = float("inf")
max_1 = -float("inf")

for i,c_i in enumerate(c):
    x = exp(data[i]) if take_log else data[i]
    if c_i == 1: 
        min_1 = min(min_1,x)
        max_1 = max(max_1,x)
    else: 
        min_0 = min(min_0,x)
        max_0 = max(max_0,x)

print(min_1,max_1,min_0,max_0)        
