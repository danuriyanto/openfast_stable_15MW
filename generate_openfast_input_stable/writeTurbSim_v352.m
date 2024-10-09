function[] = writeTurbSim_v352(TurbSim)

C(1,1) = {'---------TurbSim v2.00.* Input File------------------------'};
C(end+1,1) = {'Example       input         - file for TurbSim.'};

C(end+1,1) = {'---------Runtime Options-----------------------------------'};
C(end+1,1) = {'False         Echo          - Echo input data to <RootName>.ech (flag)'};
C(end+1,1) = {[num2str(TurbSim.RandSeed1),'         RandSeed1     - First random seed (-2147483648 to 2147483647)']};
C(end+1,1) = {'RANLUX        RandSeed2     - Second random seed (-2147483648 to 2147483647) for intrinsic pRNG, or an alternative pRNG: "RanLux" or "RNSNLW"'};
C(end+1,1) = {'False         WrBHHTP       - Output hub-height turbulence parameters in binary form? (Generates RootName.bin)'};
C(end+1,1) = {'False         WrFHHTP       - Output hub-height turbulence parameters in formatted form? (Generates RootName.dat)'};
C(end+1,1) = {'False         WrADHH        - Output hub-height time-series data in AeroDyn form? (Generates RootName.hh)'};
C(end+1,1) = {'True          WrADFF        - Output full-field time-series data in TurbSim/AeroDyn form? (Generates RootName.bts)'};
C(end+1,1) = {'False         WrBLFF        - Output full-field time-series data in BLADED/AeroDyn form? (Generates RootName.wnd)'};
C(end+1,1) = {'False         WrADTWR       - Output tower time-series data? (Generates RootName.twr)'};
C(end+1,1) = {'False         WrFMTFF       - Output full-field time-series data in formatted (readable) form? (Generates RootName.u, RootName.v, RootName.w)'};
C(end+1,1) = {'False         WrACT         - Output coherent turbulence time steps in AeroDyn form? (Generates RootName.cts)'};
C(end+1,1) = {'True          Clockwise     - Clockwise rotation looking downwind? (used only for full-field binary files - not necessary for AeroDyn)'};
C(end+1,1) = {'0             ScaleIEC      - Scale IEC turbulence models to exact target standard deviation? [0=no additional scaling; 1=use hub scale uniformly; 2=use individual scales]'};
C(end+1,1) = {''};

C(end+1,1) = {'--------Turbine/Model Specifications-----------------------'};
C(end+1,1) = {'15            NumGrid_Z     - Vertical grid-point matrix dimension'};
C(end+1,1) = {'15            NumGrid_Y     - Horizontal grid-point matrix dimension'};
C(end+1,1) = {'0.1          TimeStep      - Time step [seconds]'};
C(end+1,1) = {[num2str(TurbSim.AnalysisTime),'          AnalysisTime  - Length of analysis time series [seconds] (program will add time if necessary: AnalysisTime = MAX(AnalysisTime, UsableTime+GridWidth/MeanHHWS) )']};
C(end+1,1) = {'"ALL"         UsableTime    - Usable length of output time series [seconds] (program will add GridWidth/MeanHHWS seconds unless UsableTime is "ALL")'};
C(end+1,1) = {'150           HubHt         - Hub height [m] (should be > 0.5*GridHeight)'};
C(end+1,1) = {'289.5         GridHeight    - Grid height [m]'};
C(end+1,1) = {'280.0         GridWidth     - Grid width [m] (should be >= 2*(RotorRadius+ShaftLength))'};
C(end+1,1) = {'0             VFlowAng      - Vertical mean flow (uptilt) angle [degrees]'};
C(end+1,1) = {'0             HFlowAng      - Horizontal mean flow (skew) angle [degrees]'};
C(end+1,1) = {''};

C(end+1,1) = {'--------Meteorological Boundary Conditions-------------------'};
C(end+1,1) = {'"IECKAI"      TurbModel     - Turbulence model ("IECKAI","IECVKM","GP_LLJ","NWTCUP","SMOOTH","WF_UPW","WF_07D","WF_14D","TIDAL","API","USRINP","TIMESR", or "NONE")'};
C(end+1,1) = {'"unused"      UserFile      - Name of the file that contains inputs for user-defined spectra or time series inputs (used only for "USRINP" and "TIMESR" models)'};
C(end+1,1) = {'"3"           IECstandard   - Number of IEC 61400-x standard (x=1,2, or 3 with optional 61400-1 edition number (i.e. "1-Ed2") )'};
C(end+1,1) = {'11            IECturbc      - IEC turbulence characteristic ("A", "B", "C" or the turbulence intensity in percent) ("KHTEST" option with NWTCUP model, not used for other models)'};
C(end+1,1) = {'"NTM"         IEC_WindType  - IEC turbulence type ("NTM"=normal, "xETM"=extreme turbulence, "xEWM1"=extreme 1-year wind, "xEWM50"=extreme 50-year wind, where x=wind turbine class 1, 2, or 3)'};
C(end+1,1) = {'default       ETMc          - IEC Extreme Turbulence Model "c" parameter [m/s]'};
C(end+1,1) = {'"PL"          WindProfileType - Velocity profile type ("LOG";"PL"=power law;"JET";"H2L"=Log law for TIDAL model;"API";"USR";"TS";"IEC"=PL on rotor disk, LOG elsewhere; or "default")'};
C(end+1,1) = {'"unused"      ProfileFile   - Name of the file that contains input profiles for WindProfileType="USR" and/or TurbModel="USRVKM" [-]'};
C(end+1,1) = {'150           RefHt         - Height of the reference velocity (URef) [m]'};
C(end+1,1) = {[num2str(TurbSim.Vhub),'          URef          - Mean (total) velocity at the reference height [m/s] (or "default" for JET velocity profile) [must be 1-hr mean for API model; otherwise is the mean over AnalysisTime seconds]']};
C(end+1,1) = {'default       ZJetMax       - Jet height [m] (used only for JET velocity profile, valid 70-490 m)'};
C(end+1,1) = {'0.12          PLExp         - Power law exponent [-] (or "default")'};
C(end+1,1) = {'default       Z0            - Surface roughness length [m] (or "default")'};
C(end+1,1) = {''};

C(end+1,1) = {'--------Non-IEC Meteorological Boundary Conditions------------'};
C(end+1,1) = {'default       Latitude      - Site latitude [degrees] (or "default")'};
C(end+1,1) = {'0.05          RICH_NO       - Gradient Richardson number [-]'};
C(end+1,1) = {'default       UStar         - Friction or shear velocity [m/s] (or "default")'};
C(end+1,1) = {'default       ZI            - Mixing layer depth [m] (or "default")'};
C(end+1,1) = {'default       PC_UW         - Hub mean uw Reynolds stress [m^2/s^2] (or "default" or "none")'};
C(end+1,1) = {'default       PC_UV         - Hub mean uv Reynolds stress [m^2/s^2] (or "default" or "none")'};
C(end+1,1) = {'default       PC_VW         - Hub mean vw Reynolds stress [m^2/s^2] (or "default" or "none")'};
C(end+1,1) = {''};

C(end+1,1) = {'--------Spatial Coherence Parameters----------------------------'};
C(end+1,1) = {'default       SCMod1        - u-component coherence model ("GENERAL", "IEC", "API", "NONE", or "default")'};
C(end+1,1) = {'default       SCMod2        - v-component coherence model ("GENERAL", "IEC", "NONE", or "default")'};
C(end+1,1) = {'default       SCMod3        - w-component coherence model ("GENERAL", "IEC", "NONE", or "default")'};
C(end+1,1) = {'default       InCDec1       - u-component coherence parameters for general or IEC models [-, m^-1] (e.g. "10.0 0.3e-3" in quotes) (or "default")'};
C(end+1,1) = {'default       InCDec2       - v-component coherence parameters for general or IEC models [-, m^-1] (e.g. "10.0 0.3e-3" in quotes) (or "default")'};
C(end+1,1) = {'default       InCDec3       - w-component coherence parameters for general or IEC models [-, m^-1] (e.g. "10.0 0.3e-3" in quotes) (or "default")'};
C(end+1,1) = {'default       CohExp        - Coherence exponent for general model [-] (or "default")'};
C(end+1,1) = {''};

C(end+1,1) = {'--------Coherent Turbulence Scaling Parameters-------------------'};
C(end+1,1) = {'C:/TurbSim/CertTest/EventData CTEventPath   - Name of the path where event data files are located'};
C(end+1,1) = {'"Random"      CTEventFile   - Type of event files ("LES", "DNS", or "RANDOM")'};
C(end+1,1) = {'True          Randomize     - Randomize the disturbance scale and locations? (true/false)'};
C(end+1,1) = {'1.0           DistScl       - Disturbance scale [-] (ratio of event dataset height to rotor disk). (Ignored when Randomize = true.)'};
C(end+1,1) = {'0.5           CTLy          - Fractional location of tower centerline from right [-] (looking downwind) to left side of the dataset. (Ignored when Randomize = true.)'};
C(end+1,1) = {'0.5           CTLz          - Fractional location of hub height from the bottom of the dataset. [-] (Ignored when Randomize = true.)'};
C(end+1,1) = {'30.0          CTStartTime   - Minimum start time for coherent structures in RootName.cts [seconds]'};
C(end+1,1) = {''};

C(end+1,1) = {'===================================================='};
C(end+1,1) = {'! NOTE: Do not add or remove any lines in this file!'};
C(end+1,1) = {'===================================================='};

writecell(C,TurbSim.FileName,QuoteStrings="none",FileType="text",WriteMode="overwrite");
