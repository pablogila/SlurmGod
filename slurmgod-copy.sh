#!/bin/bash

###########################################################
# This script will create a slurm file in each subfolder.
# Inside each subfolder there must be only one input file.
# You need a slurm template on the same root folder as this
# script, containing the strings "FILENAME" and "JOBNAME",
# see the following example:
#    !/bin/bash
#    #SBATCH -J JOBNAME
#    [...]
#    cp2k.psmp -o FILENAME.out -i FILENAME.inp
###########################################################
slurm_template="cp2k-slurm_template.sh"
slurm_new_name="cp2k-slurm.sh"
input_extension=".inp"
###########################################################

current_dir=$(pwd)

for dir in "$current_dir"/*; do
    if [ -d "$dir" ]; then
        # Find the input/s files and save their full names
        inp_files=("$dir"/*"$input_extension")
        # If no input file is found, skip this directory
        if [ ! -f "${inp_files[0]}" ]; then
            continue
        fi

        # Job name will be the name of the folder
        job_name=$(basename "$dir")
        
        # If more than one input file is found, print an error
        if [ ${#inp_files[@]} -gt 1 ]; then
            echo "ERROR: More than one input file found in $job_name. Skipping..."
            continue
        fi
        inp_file=${inp_files[0]}

        inp_filename=$(basename "$inp_file" $input_extension) # "FILENAME"
        inp_filename_full=$(basename "$inp_file") # "FILENAME.inp"

        # Copy the slurm template file to the subdirectory
        cp "$current_dir/$slurm_template" "$dir/$slurm_new_name"

        # Rename the FILENAME and JOBNAME strings in the template file
        sed -i "s/FILENAME/$inp_filename/g" "$dir/$slurm_new_name"
        sed -i "s/JOBNAME/$job_name/g" "$dir/$slurm_new_name"

        echo "Preparing job  $job_name  with  $inp_filename_full"
    fi
done
echo "Ready to submit."

