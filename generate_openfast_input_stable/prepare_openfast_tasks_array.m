function prepare_openfast_tasks_array(numCores)
    % List all OpenFAST input files (*.fst)
    fstFiles = dir('*.fst');
    numFiles = length(fstFiles);
    
    % Calculate how many jobs are required based on numCores
    numJobs = ceil(numFiles / numCores);
    
    % Save the list of files to a text file
    fid = fopen('file_list.txt', 'w');
    for i = 1:numFiles
        fprintf(fid, '%s\n', fstFiles(i).name);
    end
    fclose(fid);
    
    % Save job and core information
    fid = fopen('job_info.txt', 'w');
    fprintf(fid, '%d\n', numJobs); % First line is number of jobs
    fprintf(fid, '%d\n', numCores); % Second line is number of cores
    fclose(fid);

    % Create a single SLURM job array script
    jobFile = 'openfast_array_job.sh';
    fid = fopen(jobFile, 'w');
    
    % Write the SLURM directives for the job array
    fprintf(fid, '#!/bin/bash\n');
    fprintf(fid, '#SBATCH --job-name=openfast_array\n');
    fprintf(fid, '#SBATCH --ntasks=1\n');
    fprintf(fid, '#SBATCH --cpus-per-task=%d\n', numCores);
    fprintf(fid, '#SBATCH --mem=128G\n');
    fprintf(fid, '#SBATCH --partition=short\n');
    fprintf(fid, '#SBATCH --time=23:58:00\n');
    fprintf(fid, '#SBATCH --output=openfast_%%A_%%a.out\n');  % %%A is job ID, %%a is array index
    
    % Use SLURM array task ID to determine which subset of files to process
    fprintf(fid, 'startIdx=$(( ($SLURM_ARRAY_TASK_ID - 1) * %d + 1 ))\n', numCores);
    fprintf(fid, 'endIdx=$(( $SLURM_ARRAY_TASK_ID * %d ))\n', numCores);
    fprintf(fid, 'if [ "$endIdx" -gt "%d" ]; then endIdx=%d; fi\n', numFiles, numFiles);  % Cap endIdx at numFiles

    % Load MATLAB module and run MATLAB with OpenFAST commands
    fprintf(fid, 'module load matlab\n');
    fprintf(fid, 'matlab -nodisplay -nosplash -r "');
    fprintf(fid, 'fileID = fopen(''file_list.txt'', ''r''); ');
    fprintf(fid, 'fstFiles = textscan(fileID, ''%%s''); fclose(fileID); ');
    fprintf(fid, 'parpool(%d); ', numCores);
    fprintf(fid, 'parfor i = $startIdx:$endIdx, ');
    fprintf(fid, 'system(sprintf(''openfast %%s'', fstFiles{1}{i})); end; exit;"\n');
    
    fclose(fid);
end