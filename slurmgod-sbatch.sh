#!/bin/bash

############################################################
# This script will sbatch the slurm files in each subfolder.
# The slurm file must be named as follows:
# (HINT: same as 'slurm_new_name' in 'slurmgod-create.sh')
############################################################
slurm_file="slurm.sh"
############################################################

current_dir=$(pwd)

for dir in "$current_dir"/*; do
    if [ -d "$dir" ]; then
        # If no input file is found, skip this directory
        if [ ! -f "$dir"/$slurm_file ]; then
            continue
        fi
        
        cd ${dir}
        sbatch $slurm_file
        cd ..

        job_name=$(basename "$dir")
        echo "Launching job  $job_name"
    fi
done
echo "Done."

