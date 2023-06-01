import argparse 
import sys
from treeswift import *



def get_outputs(resultfile):
    print("Processing:", resultfile)
    res = dict()
    with open(resultfile, "r") as r:
        lines = r.readlines()

        for line in lines:
            tokens = line.split(':')
            if len(tokens) >= 2:
                if tokens[0] == 'Optimal negative-llh':
                    res['llh'] = float(tokens[1].strip())
                elif tokens[0] == 'Optimal tree':
                    res['tree'] = '[&R] ' + line.split('[&R]')[1]
                elif tokens[0] == 'Optimal silencing rate':
                    res['nu'] = float(tokens[1].strip())
                elif tokens[0] == 'Optimal dropout rate':
                    res['phi'] = float(tokens[1].strip())
        # print(res)
        t = read_tree_newick(res['tree'])

    return t, res

def build_brlen_results(tt, ested):
    results = dict()
    tt.root.h = 1
    for nidx, node in enumerate(tt.traverse_preorder()): 
        if not node.is_root():
            node.h = node.parent.h + 1
    for nidx, node in enumerate(tt.traverse_preorder()): 
        bl = node.get_edge_length()
        if bl == None:
           bl = 0.0
        results[(nidx, node.h)] = [bl]
    # print(nidx)
    for tidx, t in enumerate(ested):
        print("treeidx", tidx)
        t.root.h = 1
        for nidx, node in enumerate(t.traverse_preorder()): 
            if not node.is_root():
                node.h = node.parent.h + 1
        for nidx, node in enumerate(t.traverse_preorder()):
            # print(nidx)
            bl = node.get_edge_length()
            if bl == None:
                bl = 0.0
            results[(nidx, node.h)].append(bl)
    # print(len(results[nidx]))
        # print(nidx)
    return results

def write_brlen_results(active_flags, outfile, results):
    with open(outfile, "w+") as w:
        s = "nIdx\tnHeight\tTrueBrLen\t"
        for z in active_flags:
            s += str(z) + "\t"
        s += "\n"
        w.write(s)
        for key in results:
            nidx, nheight = key
            # print(key, results[key] is not None, results[key])
            s = str(nidx) + '\t' + str(nheight) + '\t'
            for x in results[key]:
                s += str(x) + '\t'
            s += '\n'
            w.write(s)

def write_param_results(active_flags, active_res, outfile):
    with open(outfile, "w+") as w:
        w.write("Flags\tNLL\tSilencing\tDropout\n")
        for residx, res in enumerate(active_res): 
            s = active_flags[residx] + "\t" + str(res['llh']) + "\t" + str(res['nu']) + "\t" + str(res['phi']) + '\n'
            w.write(s)
            
def run_all(tt, pre, bm, nd, nh, nm, out_brlen, out_param):
    tt = read_tree_newick(tt)
    flags = ["BothMissing", "NoDropout", "NoHeritable", "NoMissing"]
    files = []
    active_flags = []
    active_trees = []
    active_res = []
    if bm:
        s = pre + "_bothMissing.txt"
        files.append(s)
        t, t_res = get_outputs(bm)
        active_trees.append(t)
        active_res.append(t_res)
        active_flags.append(flags[0])
    if nd:
        s = pre + "_noDropout.txt"
        files.append(s)
        t, t_res = get_outputs(nd)
        active_trees.append(t)
        active_res.append(t_res)
        active_flags.append(flags[1])
    if nh:
        s = pre + "_noHeritable.txt"
        files.append(s)
        t, t_res = get_outputs(nh)
        active_trees.append(t)
        active_res.append(t_res)
        active_flags.append(flags[2])
    if nm:
        s = pre + "_noMissing.txt"
        files.append(s)
        t, t_res = get_outputs(nm)
        active_trees.append(t)
        active_res.append(t_res)
        active_flags.append(flags[3])

    brlen_results = build_brlen_results(tt, active_trees)
    write_brlen_results(active_flags, out_brlen, brlen_results)
    
    write_param_results(active_flags, active_res, out_param)

tt = sys.argv[1]
#bm = sys.argv[2]
#nd = sys.argv[3]
#nh = sys.argv[4]
#nm = sys.argv[5]
out_brlen = sys.argv[6]
out_param = sys.argv[7]

p = argparse.ArgumentParser()
p.add_option('-bm', action="store_true")
p.add_option('-nd', action="store_true")
p.add_option('-nm', action="store_true")
p.add_option('-nh', action="store_true")
p.add_argument('--tt', type=str)
p.add_argument('--pre', type=str)
p.add_argument('--out_brlen', type=str)
p.add_argument('--out_param', type=str)

opts, args = p.parse_args()
tt = args.tt
pre = args.pre
out_brlen = args.out_brlen
out_param = args.out_param
bm, nd, nh, nm = opts.bm, opts.nd, opts.nh, opts.nm

run_all(tt, pre, bm, nd, nh, nm, out_brlen, out_param)
