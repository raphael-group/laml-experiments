#! /usr/bin/env python

import jenkspy
from sys import argv
from math import log,exp

input_file = argv[1]
k = int(argv[2])
take_log = bool(argv[3])

with open(input_file,'r') as fin:
    data = [float(x) for x in fin.readlines()]
    if take_log:
        data = [log(x) for x in data if x>0]

data.sort()
print(data)
breaks = jenkspy.jenks_breaks(data, n_classes=k)
if take_log:
    breaks = [exp(x) for x in breaks]
print(breaks)
