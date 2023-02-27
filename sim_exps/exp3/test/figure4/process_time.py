 
def proc_to_sec(v):
 	#for k, v in df.iteritems():
	 m = v.split('m')[0]
	 s = v.split('m')[1].rstrip()[:-1]
	 m = int(m) * 60
	 s = float(s)
	 return m + s

def proc_to_min(v):
 	#for k, v in df.iteritems():
	return proc_to_sec(v) / 60

f = "exp3/experiment_time.csv"
outfile = "exp3/experiment_time.proc.csv"
#f = "exp3_experiment_varyn_time.csv"
#f = "exp3/runtime_n150_nm.txt"
#outfile = "exp3/runtime_n150_nm.proc.txt"

#f = "exp3/runtime_n150_nm_noEM.txt"
#outfile = "exp3/runtime_n150_nm_noEM.proc.txt"

with open(outfile, "w+") as w:
	with open(f, "r") as r:
		lines = r.readlines()
		w.write(lines[0])
		#for line in lines:
		for line in lines[1:]:
			tokens = line.split(',')
			tokens[-1] = str(proc_to_min(tokens[-1]))
			w.write(','.join(tokens) + "\n")
