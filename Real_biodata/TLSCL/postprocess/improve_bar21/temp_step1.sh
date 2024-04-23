# step 1a: perform topology search independently on problematic progenitor groups
python ~/my_gits/LAML/run_laml.py -c ../../bar21/Bar21_character_matrix.txt -t progenitor_6_starting.nwk -o progenitor_6_improved --topology_search --parallel -v -p ../../bar21/Bar21_priors.pickle --delimiter tab -m -1 --randomreps 15 
python ~/my_gits/LAML/run_laml.py -c ../../bar21/Bar21_character_matrix.txt -t progenitor_9_starting.nwk -o progenitor_9_improved --topology_search --parallel -v -p ../../bar21/Bar21_priors.pickle --delimiter tab -m -1 --randomreps 15 
