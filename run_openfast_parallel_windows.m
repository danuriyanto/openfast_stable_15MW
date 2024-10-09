
% List of directories
dir_files = dir("openfast_independent*");

% Initialize an empty cell array to store input file paths
inputFiles = {};

% Loop through directories to get input files
for dirnum = 1:length(dir_files)
    Files_dir = dir(fullfile(dir_files(dirnum).name, '*fst'));
    for i = 1:length(Files_dir)
        inputFiles{end+1} = fullfile(Files_dir(i).folder, Files_dir(i).name); %#ok<SAGROW>
    end
end

% Number of workers to use (cores)
numWorkers = 6;  % Adjust based on your system's performance cores

% Start parallel pool
parpool(numWorkers);

% Run TurbSim simulations in parallel
parfor i = 1:length(inputFiles)
    runOpenFAST(inputFiles{i});
end

% Shut down parallel pool
delete(gcp('nocreate'));

% Define the function to run a TurbSim simulation on Windows
function runOpenFAST(inputFile)
    % Extract the file name without extension for output file naming
    [~, fileName, ~] = fileparts(inputFile);
    % Construct the command to activate conda environment and run TurbSim, redirecting output to a text file
    command = sprintf('cmd /c "conda activate openfast_stable && turbsim "%s" > %s_output.txt 2>&1"', inputFile, fileName);
    % Run the command in the system shell
    system(command, '-echo');
end

