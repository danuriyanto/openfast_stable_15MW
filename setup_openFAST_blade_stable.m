clc; clear; close all;
load designTable.mat
addpath generate_openfast_input_stable/

%global setting
simdur = 800; %simulation duration in seconds;
rng(12345)
numSeeds = 10;
simDT = 0.01;
seedpool = randi([0,1000000],numSeeds,1); %Only need random seeds for winds to repeat 1x. No need for different wind magnitudes to have different seeds
summary_openFast = struct();
FST_info = struct();
simDT = 0.01; 
numCores = 12;

for sitenum = 2 %height(designTable) %loop through sites

    % set the folder name
    sitename = designTable.Name{sitenum};
    foldername = ['openfast_blade_analysis_' sitename];
    mkdir(foldername)
    
    % copy the main folder to each running folder and go into site folder
    copyfile("IEA-15-240-RWT-Monopile_DISCON.IN", foldername)
    copyfile("IEA-15-240-RWT", [foldername '/IEA-15-240-RWT']);

    cd(foldername)
    % delete all the input files if exists
    ext = {'*.Inp','*.fst','*.ech','*.txt','*.out','*.sh','*.bts'};
    extensions = cellfun(@(x)dir(fullfile(pwd,x)),ext,'UniformOutput',false);
    extensions = vertcat(extensions{:});
    if ~isempty(extensions)
        delete(extensions.name);
    end

    bladepitch_array = [5 6 7];
    Vhub_array       = [9 10 11];
    Hs_array         = ones(size(Vhub_array)) * 0.01;

    [BP, VH, HS] = ndgrid(bladepitch_array, Vhub_array, Hs_array);
    combinations = [BP(:), VH(:), HS(:)];
    combinationsTable = array2table(combinations, 'VariableNames', {'BladePitch', 'Vhub', 'Hs'});


    % generate the openfast simulation input for the specific site
    for pairnum=1:numel(combinationsTable.BladePitch)
        
        % set the Vhub, Hs and Tp from the seastate pairs
        Vhub = combinationsTable.Vhub(pairnum);
        Hs   = combinationsTable.Hs(pairnum);
        BladePitch = combinationsTable.BladePitch(pairnum);

        for nseed=1:numel(seedpool)
            seed = seedpool(nseed);
            runIndex = numSeeds*(pairnum-1) + nseed;
            Tp = 4.3*sqrt(Hs); % Spectral peak period (sec)

            % set the environmental criteria
            waterdepth = designTable.Depth_m_(sitenum); % waterdepth m
            wavedir = 0; % wave attack angle (degree)
            winddir = 0; % wind attack angle (degree)

            % structure properties
            interface_loc           = designTable.InterfaceElevation(sitenum);
            diameter_mudline        = designTable.BottomDiameter(sitenum);
            diameter_interface      = designTable.TopDiameter(sitenum);
            thickness_mudline       = designTable.BottomThickness(sitenum);
            thickness_interface     = designTable.TopThickness(sitenum);

            %make empty structures for each simulation input:
            SubDyn      = struct();
            HydroDyn    = struct();
            AeroDyn     = struct();
            ServoDyn    = struct();
            ElastoDyn   = struct();
            InflowWind  = struct();
            TurbSim     = struct();
            fst         = struct();

            % file naming
            site_name               = designTable.Name{sitenum};
            env_info                = ['_Vhub_'      num2str(Vhub) ...
                                       '_BladePitch_' num2str(BladePitch) ... 
                                       '_seed_'      num2str(seed)];
            env_info_wind_only      = ['_Vhub_' num2str(Vhub) '_seednum_' num2str(seed)];
            SubDyn.FileName         = [site_name env_info '.SubDyn.Inp'];
            HydroDyn.FileName       = [site_name env_info '.HydroDyn.Inp'];
            AeroDyn.FileName        = [site_name env_info '.AeroDyn.Inp'];
            ServoDyn.FileName       = [site_name env_info '.ServoDyn.Inp'];
            ElastoDyn.FileName      = [site_name env_info '.ElastoDyn.Inp'];
            TurbSim.FileName        = ['Turbsim' ...
                                       env_info_wind_only '.Turbsim.Inp'];
            InflowWind.FileName     = [site_name env_info '.Inflow.Inp'];
            fst.FileName            = [site_name env_info '.fst'];

            % setup SubDyn input file
            SubDyn.Mudline_loc          = waterdepth;
            SubDyn.Interface_loc        = interface_loc;
            SubDyn.Thickness_Mudline    = thickness_mudline;
            SubDyn.Thickness_Interface  = thickness_interface;
            SubDyn.Diameter_Mudline     = diameter_mudline;
            SubDyn.Diameter_Interface   = diameter_interface;
            SubDyn.SSI_File             = ssiFileLookup(site_name);
            SubDyn.env_info             = env_info;
            writeSubDyn_v352_stable(SubDyn);

            % setup HydroDyn input file
            HydroDyn.WaterDepth         = waterdepth;
            HydroDyn.Transition_Height  = interface_loc;
            HydroDyn.Diameter           = diameter_mudline;
            HydroDyn.Thickness          = thickness_mudline;
            HydroDyn.env_info           = env_info;
            HydroDyn.WaveMod            = 1; %{0: none=still water, 1: regular (periodic), 1P#: regular with user-specified phase, 2: JONSWAP/Pierson-Moskowitz spectrum (irregular), 3: White noise spectrum (irregular), 4: user-defined spectrum from routine UserWaveSpctrm (irregular), 5: Externally generated wave-elevation time series, 6: Externally generated full wave-kinematics time series [option 6 is invalid for PotMod/=0]}
            HydroDyn.WaveStMod          = 0; %{0: none=no stretching, 1: vertical stretching, 2: extrapolation stretching, 3: Wheeler stretching}
            HydroDyn.WaveTMax           = simdur;
            HydroDyn.WaveDT             = 0.1;
            HydroDyn.WaveHs             = Hs;
            HydroDyn.WaveTp             = Tp;
            HydroDyn.WaveDir            = wavedir;
            HydroDyn.WaveSeed           = seed;
            HydroDyn.CurrMod            = 0;
            HydroDyn.CurrSSV0           = 0;
            writeHydroDyn_v352_stable(HydroDyn);

            % setup AeroDyn input file
            AeroDyn.WakeMod   = 0;
            AeroDyn.AFAeroMod = 1;
            writeAeroDyn_v352(AeroDyn);

            % setup ServoDyn input file
            ServoDyn.DLL_FileName = '/Users/macbook/miniconda3/envs/openfast_seastate/lib/libdiscon.dylib';
            writeServoDyn_v352(ServoDyn);

            % setup ElastoDyn input file
            ElastoDyn.NacYaw    = 0; % nacelle yaw angle
            ElastoDyn.BlPitch   = BladePitch; %blade pitch, 90 deg == feathered blade
            ElastoDyn.RotSpeed  = 0; % initial rotor speed
            ElastoDyn.Azimuth   = 0;
            ElastoDyn.GenDOF    = 'True'; % True = idling, False = fixed
            writeElastoDyn_v352(ElastoDyn);

            % setup Turbsim simulation
            TurbSim.RandSeed1    = seed;
            TurbSim.AnalysisTime = simdur;
            TurbSim.Vhub         = Vhub;
            writeTurbSim_v352(TurbSim);

            % setup inflowwind input file
            InflowWind.WindType         = 3;
            InflowWind.PropagationDir   = winddir;
            InflowWind.HWindSpeed       = Vhub;
            InflowWind.FileName_BTS     = ['../all_bts/' TurbSim.FileName(1:end-4) '.bts'];
            writeInflowWind_v352(InflowWind);

            % setup the OpenFast .fst file
            fst.echo        = 'True';
            fst.env_info    = env_info;
            fst.Tmax        = simdur; %simulation duration
            fst.DT          = simDT; %simulation DT
            fst.CompElast   = 1; % {1=ElastoDyn; 2=ElastoDyn + BeamDyn for blades}
            fst.CompInflow  = 1; % {0=still air; 1=InflowWind; 2=external from OpenFOAM}
            fst.CompAero    = 2; % {0=None; 1=AeroDyn v14; 2=AeroDyn v15}
            fst.CompServo   = 0; % {0=None; 1=ServoDyn}
            fst.CompHydro   = 1; % {0=None; 1=HydroDyn}
            fst.CompSub     = 1; % {0=None; 1=SubDyn; 2=External Platform MCKF}
            fst.WtrDpth     = waterdepth;% waterdepth in m
            fst.MSL2SWL     = 0; % Mean Sea Level distance to Still Water Level (positive)
            fst.EDFile      = ElastoDyn.FileName; % ElastoDyn input file
            fst.AeroFile    = AeroDyn.FileName; % AeroDyn input file
            fst.ServoFile   = ServoDyn.FileName;  % ServoDyn input file
            fst.HydroFile   = HydroDyn.FileName;  % Hydrodyn input file
            fst.SubFile     = SubDyn.FileName;    % Subdyn input file
            fst.InflowFile  = InflowWind.FileName; %inflow wind input file
            fst.FolderName  = foldername;
            writeFST_v352_stable(fst);


            % save all the fst properties in the summary struct
            summary_openFast(pairnum).sitename   = site_name;
            summary_openFast(pairnum).Hs         = Hs;
            summary_openFast(pairnum).Vhub       = Vhub;
            summary_openFast(pairnum).seed       = seed;
            summary_openFast(pairnum).SubDyn     = SubDyn;
            summary_openFast(pairnum).HydroDyn   = HydroDyn;
            summary_openFast(pairnum).AeroDyn    = AeroDyn;
            summary_openFast(pairnum).ServoDyn   = ServoDyn;
            summary_openFast(pairnum).ElastoDyn  = ElastoDyn;
            summary_openFast(pairnum).InflowWind = InflowWind;
            summary_openFast(pairnum).TurbSim    = TurbSim;
            summary_openFast(pairnum).fst        = fst;

        end
    end
    prepare_openfast_tasks_array(numCores)
    prepare_turbsim_tasks_array(numCores)
    copyfile('../submit_jobs_openfast_array.sh', './');
    copyfile('../submit_jobs_turbsim_array.sh', './');
    system('chmod +x *sh')
    movefile("*.Turbsim.Inp", "../all_bts/")
    cd ../
end

cd all_bts/
prepare_turbsim_tasks_array(numCores)
copyfile('../submit_jobs_turbsim_array.sh', './');
cd ../

fprintf('FINISH!!!!')

