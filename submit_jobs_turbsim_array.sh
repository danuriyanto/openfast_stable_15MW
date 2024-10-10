#!/bin/bash
#SBATCH --job-name=turbsim_array   # Job name
#SBATCH --ntasks=1                 # One task per job
#SBATCH --mem=16G                  # Memory per node
#SBATCH --partition=short          # Partition name
#SBATCH --time=23:58:00            # Time limit
#SBATCH --output=turbsim_%A_%a.out # Output file for the array
#SBATCH --error=error_%A_%a.err    # Error file for the array

# Read the number of jobs from turbsim_job_info.txt
read numJobs < <(head -n 1 turbsim_job_info.txt)

# Submit a single job array with numJobs tasks
sbatch --array=1-${numJobs} turbsim_array_job.sh