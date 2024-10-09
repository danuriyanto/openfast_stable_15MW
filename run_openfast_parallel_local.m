clear; clc;

% List of input directories
dir_files = dir("openfast_blade*");

% Number of workers to use (cores)
numWorkers = 6;  % Adjust based on your system's performance cores

% Start parallel pool
parpool(numWorkers);

% loop for all locations
for loc=1
    Files_dir = dir([dir_files(loc).name '/*fst']);
    inputFiles = {Files_dir.name}';
    
    % set the current directory to the current location
    cd(dir_files(loc).name)
    % Run openfast simulations in parallel
    parfor i = 1:length(inputFiles)
        runOpenFAST(inputFiles{i});
    end
    cd ../
end
% Shut down parallel pool
delete(gcp('nocreate'));

% Define the function to run a TurbSim simulation
function runOpenFAST(inputFile)
    % Construct the command to activate conda environment and run TurbSim
    [~, fileName, ~] = fileparts(inputFile);
    command = sprintf('source ~/.bash_profile && conda activate openfast_stable && openfast "%s" > %s_output.txt 2>&1', inputFile, fileName);
    % Run the command in the system shell
    system(command, '-echo');
end