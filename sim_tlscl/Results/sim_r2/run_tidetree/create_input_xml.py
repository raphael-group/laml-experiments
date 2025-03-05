import sys
# task is to copy the xml file and automate edits so that we create an xml file for each of the intMEMOIR input files

# input data file example: /Users/gc3045/problin_experiments/Real_biodata/intMEMOIR/s10c1/characters.proc.csv
# cell,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9
# 216_1,1,1,1,2,2,1,2,0,0,1

sys.path.append('/Users/gc3045/scmail_v1/LAML/laml_libs')
from sequence_lib import read_sequences, read_priors

print("ONLY WORKS FOR 3 STATES FOR NOW")
name = sys.argv[1] #"s5c3" #"s10c1"
inFile = sys.argv[2]
inPriors = sys.argv[3]
outFile = sys.argv[4]

# read in file, and copy each line until section on input data
dirname="/Users/gc3045/old_problin/problin/running_tidetree"
template = open(f"/Users/gc3045/laml_experiments/rebuttal/tidetree/examples/exampleMoreStates.xml", "r") #template.xml", "r")
#template = open(f"/Users/gc3045/laml_experiments/rebuttal/tidetree/examples/example.xml", "r") #template.xml", "r")

# Step 1: Overwrite the input sequences
# Step 2: Overwrite the input edit rate frequencies
# Step 3: Overwrite the nrstates
# Step 4: write: col_idx, orig_state, new_state
# Step 5: Use the nexus convention, '?' for missing data

inData = open(inFile, "r")
#inPriors = open(inPriors, "r")
newFile = open(outFile, "w+")

msa = read_sequences(inFile)
Q = read_priors(inPriors, msa)

freq_arr = []
state_idx = 2
col_dict_mapping = {}
new_seqs = {}
for i, charLine in enumerate(inData.readlines()[1:]):
    tokens = charLine.split(',')
    cellName = tokens[0]
    #values = ','.join([x.rstrip() for x in tokens[1:]])
    seq = [x.rstrip() for x in tokens[1:]]
    new_seq = []
    for col_idx in range(len(seq)):
        q_i = Q[col_idx]
        if col_idx not in col_dict_mapping:
            # keep convention of [unedited, silenced, edited...], not specified anywhere.
            col_dict_mapping[col_idx] = {'0': 0, '-1': '1'} # data format only takes integers
        val = seq[col_idx]
        if val not in col_dict_mapping[col_idx].keys():
            col_dict_mapping[col_idx][val] = state_idx
            rate = q_i[int(val)]
            freq_arr.append(str(rate))
            state_idx += 1
        new_val = col_dict_mapping[col_idx][val]
        new_seq.append(new_val)
        new_seqs[cellName] = ','.join([str(x) for x in new_seq])

print('state_idx', state_idx)
print('Freqstr', len(freq_arr))

inData.seek(0)

freq_arr = [str(1/len(freq_arr)) for _ in range(len(freq_arr))]
freqstr = ' '.join(freq_arr)
wrote_input = False
numCells = 0
inputSection = False
editFreqSection = False
for line in template.readlines():
    if line == "<!-- input data -->\n":
        inputSection = True
    elif line == "<!-- define set of taxa based on alignment - cells in this context -->\n":
        print("done with inputSection")
        inputSection = False
    elif line == "        <!-- find the definition of the scarring, loss rate and clock rate in the TiDeTree manuscript -->\n":
        newFile.write(line)
        print("in edit freq section")
        editFreqSection = True
        wrote_input = False
    elif line == "        <!-- the clock rate is the rate of acquiring edited state 2  -->\n":
        print("done with edit freq section")
        editFreqSection = False


    if inputSection:
        if not wrote_input:
            # naming it s1_c1_data so I don't have to change it elsewhere
            newFile.write(f'<data  id="s1_c1_data.txt" spec="Alignment" name="alignment">\n')
            newFile.write('    <userDataType spec="tidetree.evolution.datatype.EditData"\n')
            newFile.write(f'                     nrOfStates="{state_idx}" />\n')
            for i, charLine in enumerate(inData.readlines()[1:]):
                tokens = charLine.split(',')
                cellName = tokens[0]
                if i < 20:
                #values = ','.join([x.rstrip() for x in tokens[1:]])
                #newFile.write(f'<sequence id="{cellName}" spec="Sequence" taxon="{cellName}" value="{values}"/>\n')
                    newFile.write(f'<sequence id="{cellName}" spec="Sequence" taxon="{i}" value="{new_seqs[cellName]}"/>\n')
            numCells = 20
            #numCells = i
            newFile.write('</data>\n')
            newFile.write('\n')
        wrote_input = True
    elif editFreqSection:
        if not wrote_input: 
            newFile.write('           <parameter id="editRate" spec="parameter.RealParameter"\n')
            newFile.write('            dimension="1" lower="0.0" name="stateNode"\n')
            newFile.write(f'            upper="1000"> {freqstr}\n')
            newFile.write('            </parameter>\n')
            newFile.write('            <parameter id="silencingRate" spec="parameter.RealParameter" dimension="1"\n')
            newFile.write('            lower="0.0" name="stateNode" upper="1000"> 0.134 </parameter>\n') # giving it close to the true
            newFile.write('\n')
        wrote_input = True
    #elif line == '    <frequencies spec="beast.base.evolution.substitutionmodel.Frequencies" frequencies="1 0 0 0" estimate="false"/>\n':
    #    freq_str = ' '.join(['1'] + ['0' for _ in range(state_idx - 2)]) # for silenced and unedited
    #    newFile.write(f'    <frequencies spec="beast.base.evolution.substitutionmodel.Frequencies" frequencies="{freq_str}" estimate="false"/>\n')
    else:
        newFile.write(line)
