#!/bin/bash

input_file="/n/fs/ragr-data/users/gchu/sim_tlscl_r2/runjobs/scalability/batchids_laml_fastEM_gpu_missing.txt" 
#batchids_startle_all.txt" #batchids_nj_all.txt" #batchids_laml_fastEM_cpu.txt" #batchids_greedy.txt"
output_file="laml_fastEM_gpu_resource_results.csv" 
#startle_resource_results.csv" #nj_resource_results.csv" #laml_fastEM_cpu_resource_results.csv" #greedy_resource_results.csv"
rm -rf $output_file
# Write CSV header
echo "model_condition,method,memory_kb,cpu_percent,runtime_seconds" > $output_file

while IFS=',' read -r job_name job_id command; do
    # Extract model condition from the command
    model_condition=$(echo $command | grep -oP 'k\d+M\d+p\d+_\w+_\w+_r\d+' | head -n 1)
    echo $model_condition
    
    # Get job stats
    job_stats=$(sacct -j $job_id --format=JobID,MaxRSS,TotalCPU,Elapsed -n | grep "ba")
    
    if [ -n "$job_stats" ]; then
        # Extract memory, CPU time, and elapsed time
        memory_kb=$(echo $job_stats | awk '{print $2}' | sed 's/K//')

        cpu_percent=$(seff $job_id | grep "CPU Efficiency" | awk -F': ' '{ print $2 }' | awk -F'%' '{ print $1 }')

        elapsed_time=$(echo $job_stats | awk '{print $4}')
        elapsed_minutes=$(echo $elapsed_time | cut -d':' -f1)
        elapsed_seconds=$(echo $elapsed_time | cut -d':' -f2 | sed 's/\..*//')
        elapsed_total_seconds=$(echo "$elapsed_minutes * 60 + $elapsed_seconds" | bc)

        # Write to CSV
        echo "$model_condition,greedy,$memory_kb,$cpu_percent,$elapsed_total_seconds" >> $output_file
    else
        echo "No data found for job ID: $job_id" >&2
    fi
done < "$input_file"

echo "Results written to $output_file"

