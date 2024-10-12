clear; clc;

% List of input files
dir_files = dir("all_bts/*Inp");

% Number of workers to use (cores)
numWorkers = 6;  % Adjust based on your system's performance cores

% Start parallel pool
parpool(numWorkers);

cd(dir_files(1).folder)
% Run TurbSim simulations in parallel
inputFiles = ({dir_files.name})';
parfor i = 1:length(inputFiles)
    runTurbSim(inputFiles{i});
end
cd ../
% Shut down parallel pool
delete(gcp('nocreate'));

% Define the function to run a TurbSim simulation
function runTurbSim(inputFile)
[~, fileName, ~] = fileparts(inputFile);
% Construct the command to activate conda environment and run TurbSim
command = sprintf('source ~/.bash_profile && conda activate openfast_stable && turbsim "%s" > %s_output.txt 2>&1', inputFile, fileName);
% Run the command in the system shell
system(command, '-echo');
end