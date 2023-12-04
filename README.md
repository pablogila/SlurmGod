# SlurmGod

SlurmGod is a set of scripts to help you manage your slurm jobs. It allows you to create multiple jobs at once from a template, as well as sbatch'ing them. The file structure looks like this:  

```
root_folder
│
├── slurmgod-create.sh
├── slurmgod-sbatch.sh
│
├── custom_slurm_template.sh
│
├── job_folder_1
│   ├── input_file_1
│   └── ...
├── job_folder_2
│   ├── input_file_1
│   └── ...
└── ...
```

The slurm files will be created inside each job folder with the **slurmgod-create.sh** script, and then sbatch'ed with **slurmgod-sbatch.sh**.  


## Creating jobs from a template

To create all slurm jobs at once, first place a custom slurm template in the root folder. The template should contain the keywords `JOBNAME` and `FILENAME`.  
An example for a CP2K slurm template file:  

```bash
#!/bin/bash
[...]
#SBATCH -J JOBNAME
[...]
cp2k.psmp -o FILENAME.out -i FILENAME.inp
```

Then, on the `slurmgod-create.sh` file, update the variables `slurm_template`, `slurm_new_name` and `input_extension`.  

Finally, run the script:  

```bash
source slurmgod-create.sh
```

## Launching jobs

To launch the jobs, make sure that the variable `slurm_file` in the **slurmgod-sbatch.sh** is the same as the variable `slurm_new_name` previously used in **slurmgod-sbatch.sh**.  
Then, run the script:  

```bash
source slurmgod-sbatch.sh
```

