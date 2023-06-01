import pandas as pd
import sys
import argparse
import numpy as np

import networkx as nx
import cassiopeia as cas

from collections import defaultdict

def tree_to_newick(T, root=None):
    if root is None:
        roots = list(filter(lambda p: p[1] == 0, T.in_degree()))
        assert 1 == len(roots)
        root = roots[0][0]
    subgs = []
    while len(T[root]) == 1:
        root = list(T[root])[0]
    for child in T[root]:
        while len(T[child]) == 1:
            child = list(T[child])[0]
        if len(T[child]) > 0:
            subgs.append(tree_to_newick(T, root=child))
        else:
            subgs.append(child)
    return "(" + ','.join(map(str, subgs)) + ")"

"""
An iterator returning (source, [dst_1, dst_2, ..., dst_N]), (N > 2),
for all edges such that,
    mu(source, dst_1) = mu(source, dst_2) = ... = mu(source, dst_N)
where mu(e) is the set of mutations of an edge e as
determined by the input labeling. That is, it returns
all indistinguishable edges. 
"""
def get_indistinguishable_edges(T, edge_labeling):
    for w in nx.nodes(T):
        ns = list(nx.neighbors(T, w))

        if len(ns) < 2:
            continue

        # a map from a set of mutations
        # to all the edges incident on w
        # with that set of mutations
        duplicate_mutations = defaultdict(list)
        for v in ns:
            duplicate_mutations[frozenset(edge_labeling[(w, v)])].append(v)

        for (ms, vs) in duplicate_mutations.items():
            if len(ms) == 0: continue # null edges are ignored
            if len(vs) < 2: continue  # edges must occur twice to be indistinguishable
            yield (w, vs)

def remove_unidentifiable_polytomies(tree):
    T = tree.get_tree_topology()
    edge_labeling = {}
    for (u, v) in tree.edges:
       edge_labeling[(u, v)] = tree.get_mutations_along_edge(u, v)  
    return T, edge_labeling
    
    # what is the point of the rest of this?
    indistinguishables = list(get_indistinguishable_edges(T, edge_labeling))
    while len(indistinguishables) != 0:
        for (w, vs) in indistinguishables:
            u = vs[0]
            for v in vs[1:]:
                print(v)
                v_children = list(nx.neighbors(T, v))
                T.remove_node(v)
                if len(v_children) == 0: # if leaf add null edge out
                    T.add_node(v)
                    T.add_edge(u, v)
                    edge_labeling[(u, v)] = []
                else:
                    for x in v_children:
                        T.add_edge(u, x)
        indistinguishables = list(get_indistinguishable_edges(T, edge_labeling))

    return T, edge_labeling

def write_to_file(ground_truth_tree, T, edge_labeling, character_matrix, prefix):
    df = character_matrix.rename(columns={idx:f'c{idx}' for idx in range(args.m)})
    df.to_csv(f'{prefix}_character_matrix.csv')
    
    with open(f'{prefix}_bltree.newick', 'w') as out:
        nwstr = ground_truth_tree.get_newick(record_branch_lengths=True)
        out.write(nwstr)

    with open(f'{prefix}_tree.newick', 'w') as out:
        out.write(tree_to_newick(T) + ';')
        out.write(nwstr)

    with open(f'{prefix}_edge_labels.csv', 'w') as out:
        out.write(f'src,dst,character,state\n')
        for (u, v) in T.edges:
            for (c, s) in edge_labeling[(u, v)]:
                out.write(f'{u},{v},c{c},{s}\n')

    with open(f'{prefix}_edgelist.csv', 'w') as out:
        out.write(f'src,dst\n')
        for (u, v) in T.edges:
            out.write(f'{u},{v}\n')

    count_dict = defaultdict(dict)
    for (u, v) in T.edges:
        for (c, s) in edge_labeling[(u, v)]:
            if s in count_dict[c]:
                count_dict[c][s] += 1
            else:
                count_dict[c][s] = 1

    with open(f'{prefix}_counts.csv', 'w') as out:
        out.write('character,state,count\n')
        for character, count_data in count_dict.items():
            for state, count in count_data.items():
                if state == 0: continue
                out.write(f'c{character},{state},{count}\n')

def main(args):
    while True:
        try: 
            np.random.seed(args.s)
            
            bd_sim = cas.sim.BirthDeathFitnessSimulator(
                birth_waiting_distribution = lambda scale: np.random.exponential(scale),
                initial_birth_scale = 0.5,
                death_waiting_distribution = lambda: np.random.exponential(1.5),
                mutation_distribution = lambda: 1 if np.random.uniform() < 0.5 else 0,
                fitness_distribution = lambda: np.random.normal(0, .5),
                fitness_base = 1.3,
                num_extant = args.n,
                random_seed=args.s+17
            )
            
            mutation_prior_values = np.random.exponential(1e-5, args.r)
            mutation_prior_values = mutation_prior_values / mutation_prior_values.sum()
            mutation_prior = {(idx+1):mutation_prior_values[idx] for idx in range(args.r)}
            
            with open(f'{args.o}_mutation_prior.csv', 'w') as out:
                out.write('character,state,probability\n')
                for character_idx in range(args.m):
                    for state, prob in mutation_prior.items():
                        out.write(f'c{character_idx},{state},{prob}\n')
            
            lt_sim = cas.sim.Cas9LineageTracingDataSimulator(
                number_of_cassettes = args.m,
                size_of_cassette = 1,
                mutation_rate = args.p,
                state_generating_distribution = lambda: np.random.exponential(args.e),
                number_of_states = args.r,
                state_priors = mutation_prior,
                heritable_silencing_rate = args.z, #0.0001,
                stochastic_silencing_rate = args.d,
                heritable_missing_data_state = -1,
                stochastic_missing_data_state = -1,
            )
            print("Simulating ground truth tree...")
            ground_truth_tree = bd_sim.simulate_tree()
            print("Simulating lineage tracing data on tree...")
            lt_sim.overlay_data(ground_truth_tree)
            ground_truth_tree.collapse_mutationless_edges(False)

            T, edge_labeling = remove_unidentifiable_polytomies(ground_truth_tree)
            print("Writing to file...")
            write_to_file(ground_truth_tree, T, edge_labeling, ground_truth_tree.character_matrix, args.o)
            break
        except cas.mixins.errors.TreeSimulatorError:
            args.s += 1
            continue

def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', type=int, help='number of cells [10]', default = 10)
    parser.add_argument('-m', type=int, help='number of characters [5]', default = 5)
    parser.add_argument('-r', type=int, help='maximum number of states per character (must be greater than 1) [5]', default = 25)
    parser.add_argument('-o', type=str, help='output prefix', default='test')
    parser.add_argument('-s', type=int, help='seed [0]', default = 0)
    parser.add_argument('-p', type=float, help='mutation probability [0.1]', default = 0.1)
    parser.add_argument('-d', type=float, help='stochastic missing data probability [0.1]', default = 0.1)
    parser.add_argument('-z', type=float, help='heritable silencing missing data probability [0.1]', default = 0.1)
    parser.add_argument('-e', type=float, help='exponential probability density function parameter [1e-5]', default=1e-5)
    args = parser.parse_args(None if sys.argv[1:] else ['-h'])

    main(args)
