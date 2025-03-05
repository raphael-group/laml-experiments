import pandas as pd
import glob
import re

def parse_model_condition(condition):
    match = re.match(r'k(\d+)M(\d+)p(\d+)_medium_sub(\d+)_r(\d+)', condition)
    if match:
        return {
            'num_chars': int(match.group(1)),
            'alphabet_size': int(match.group(2)),
            'seed_prior': int(match.group(3)),
            'num_cells': int(match.group(4)),
            'seq_prior': int(match.group(5))
        }
    return None

# List all CSV files
all_files = glob.glob("*.csv")

# Initialize an empty list to store dataframes
dfs = []

for filename in all_files:
    print(filename)
    df = pd.read_csv(filename)
    
    if 'model_condition' in df.columns:
        # Parse the model_condition column
        parsed = df['model_condition'].apply(parse_model_condition)
        df = pd.concat([df, pd.DataFrame(parsed.tolist())], axis=1)
        
        # Rename columns to match the format in evaluations.csv
        df = df.rename(columns={
            'method': 'algorithm',
            'memory_kb': 'memory_usage',
            'cpu_percent': 'cpu_usage',
            'runtime_seconds': 'runtime'
        })

        """
        ==> evaluations.csv <==
        num_chars,alphabet_size,seed_prior,num_cells,seq_prior,algorithm,memory_usage,runtime,cpu_usage

        ==> greedy_resource_results.csv <==
        model_condition,method,memory_kb,cpu_percent,runtime_seconds
        """
        
        # Convert memory from KB to bytes
        df['memory_usage'] = df['memory_usage'] #* 1024
    
    # Ensure all necessary columns exist
    for col in ['num_chars', 'alphabet_size', 'seed_prior', 'num_cells', 'seq_prior', 'algorithm', 'memory_usage', 'cpu_usage', 'runtime']:
        if col not in df.columns:
            df[col] = None
    
    dfs.append(df)

# Concatenate all dataframes
combined_df = pd.concat(dfs, ignore_index=True)

# Select and order the columns
columns = ['num_chars', 'alphabet_size', 'seed_prior', 'num_cells', 'seq_prior', 'algorithm', 'memory_usage', 'cpu_usage', 'runtime']
combined_df = combined_df[columns]

# Save the combined dataframe
combined_df.to_csv('../combined_results.csv', index=False)
