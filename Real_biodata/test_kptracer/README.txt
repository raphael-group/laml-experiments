ML 
python run_ml_solver.py -c 3724_NT_T1_character_matrix.dedup.proc.csv -t 3724_NT_T1.suppressed_unifurcations.dedup.rand100.nwk -p "uniform"  -o ml.out --delimiter "comma"
python run_ml_solver.py -c 3724_NT_T1_character_matrix.dedup.proc.csv -t 3724_NT_T1.suppressed_unifurcations.dedup.rand100.nwk -p 3724_NT_T1_priors.pkl -o ml.out --delimiter "comma"

Note that ML_solver needs to take in a character matrix file that contains all the missing characters as "?".
