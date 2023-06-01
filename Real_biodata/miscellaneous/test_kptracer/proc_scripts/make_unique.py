from problin_libs.sequence_lib import read_sequences, write_sequences

fname = "/n/fs/ragr-research/projects/problin_experiments/Real_biodata/data_kptracer/3724_NT_All/3724_NT_All_character_matrix.txt"
outfile = "3724_NT_All_character_matrix.dedup.csv"
# fname = "/n/fs/ragr-research/projects/problin_experiments/Real_biodata/data_kptracer/3724_NT_T1/3724_NT_T1_character_matrix.txt"
# outfile = "3724_NT_T1_character_matrix.dedup.csv"
msa,site_names = read_sequences(fname, filetype="charMtrx", delimiter='\t')
print(len(msa))
final_msa = dict()
seen = set()
# print(msa)
k = 0
for cellBC in msa:
    s = [str(x) for x in msa[cellBC]]
    s = ''.join(s)
    k = len(msa[cellBC])
    # print(s)
    if s not in seen:
        final_msa[cellBC] = [-1 if x == '?' else x for x in msa[cellBC]] 
        seen.add(s)
write_sequences(final_msa, k, outfile, delimiter=",")
print(len(final_msa))
