function prepare_turbsim_tasks_array(numCores)
    % List all TurbSim input files (*.Turbsim.Inp)
    turbsimFiles = dir('*.Turbsim.Inp');
    numFiles = length(turbsimFiles);
    
    % Calculate how many jobs are required based on numCores
    numJobs = ceil(numFiles / numCores);
    
    % Save the list of files to a text file
    fid = fopen('turbsim_file_list.txt', 'w');
    for i = 1:numFiles
        fprintf(fid, '%s\n', turbsimFiles(i).name);
    end
    fclose(fid);
    
    % Save job and core information
    fid = fopen('turbsim_job_info.txt', 'w');
    fprintf(fid, '%d\n', numJobs); % First line is number of jobs
    fprintf(fid, '%d\n', numCores); % Second line is number of cores
    fclose(fid);

    % Create a single SLURM job array script
    jobFile = 'turbsim_array_job.sh';
    fid = fopen(jobFile, 'w');
    
    % Write the SLURM directives for the job array
    fprintf(fid, '#!/bin/bash\n');
    fprintf(fid, '#SBATCH --job-name=turbsim_array\n');
    fprintf(fid, '#SBATCH --ntasks=1\n');
    fprintf(fid, '#SBATCH --cpus-per-task=%d\n', numCores);
    fprintf(fid, '#SBATCH --mem=128G\n');
    fprintf(fid, '#SBATCH --partition=short\n');
    fprintf(fid, '#SBATCH --time=23:58:00\n');
    fprintf(fid, '#SBATCH --output=turbsim_%%A_%%a.out\n');  % %%A is job ID, %%a is array index
    
    % Use SLURM array task ID to determine which subset of files to process
    fprintf(fid, 'startIdx=$(( ($SLURM_ARRAY_TASK_ID - 1) * %d + 1 ))\n', numCores);
    fprintf(fid, 'endIdx=$(( $SLURM_ARRAY_TASK_ID * %d ))\n', numCores);
    fprintf(fid, 'if [ "$endIdx" -gt "%d" ]; then endIdx=%d; fi\n', numFiles, numFiles);  % Cap endIdx at numFiles

    % Load MATLAB module and run MATLAB with TurbSim commands
    fprintf(fid, 'module load matlab\n');
    fprintf(fid, 'matlab -nodisplay -nosplash -r "');
    fprintf(fid, 'fileID = fopen(''turbsim_file_list.txt'', ''r''); ');
    fprintf(fid, 'turbsimFiles = textscan(fileID, ''%%s''); fclose(fileID); ');
    fprintf(fid, 'parpool(%d); ', numCores);
    fprintf(fid, 'parfor i = $startIdx:$endIdx, ');
    fprintf(fid, 'system(sprintf(''turbsim %%s'', turbsimFiles{1}{i})); end; exit;"\n');
    
    fclose(fid);
end