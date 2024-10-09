clear; clc;

% List of input files
dir_files = dir("openfast_blade*");

% Number of workers to use (cores)
numWorkers = 6;  % Adjust based on your system's performance cores

% Start parallel pool
parpool(numWorkers);

for dirnum=1%:12
    Files_dir = dir([dir_files(dirnum).name '/*Turbsim.Inp']);
    inputFiles = {Files_dir.name}';

    cd(dir_files(dirnum).name)
    % Run TurbSim simulations in parallel
    parfor i = 1:length(inputFiles)
        runTurbSim(inputFiles{i});
    end
    cd ../
end
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