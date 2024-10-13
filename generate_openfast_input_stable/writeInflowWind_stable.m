function writeInflowWind_v352(InflowWind)
    K(1,1) = {'	------- InflowWind v3.01.* INPUT FILE -------------------------------------------------------------------------	'};
K(end+1,1) = {['IEA 15 MW Offshore Reference Turbine	']};
K(end+1,1) = {['---------------------------------------------------------------------------------------------------------------	']};
K(end+1,1) = {['False Echo - Echo input data to <RootName>.ech (flag)	']};
K(end+1,1) = {[num2str(InflowWind.WindType,0) ' WindType - switch for wind file type (1=steady; 2=uniform; 3=binary TurbSim FF; 4=binary Bladed-style FF; 5=HAWC format; 6=User defined; 7=native Bladed FF)	']};
K(end+1,1) = {[num2str(InflowWind.PropagationDir,1) '0.0 PropagationDir - Direction of wind propagation (meteoroligical rotation from aligned with X (positive rotates towards -Y) -- degrees)	']};
K(end+1,1) = {['0.0 VFlowAng - Upflow angle (degrees) (not used for native Bladed format WindType=7)	']};
K(end+1,1) = {['False VelInterpCubic - Use cubic interpolation for velocity in time (false=linear, true=cubic) [Used with WindType=2,3,4,5,7]	']};
K(end+1,1) = {['1 NWindVel - Number of points to output the wind velocity (0 to 9)	']};
K(end+1,1) = {['0.0 WindVxiList - List of coordinates in the inertial X direction (m)	']};
K(end+1,1) = {['0.0 WindVyiList - List of coordinates in the inertial Y direction (m)	']};
K(end+1,1) = {['150.0 WindVziList - List of coordinates in the inertial Z direction (m)	']};

K(end+1,1) = {['================== Parameters for Steady Wind Conditions [used only for WindType = 1] =========================	']};
K(end+1,1) = {[num2str(InflowWind.HWindSpeed,2) ' HWindSpeed - Horizontal windspeed (m/s)	']};
K(end+1,1) = {['150.0 RefHt - Reference height for horizontal wind speed (m)	']};
K(end+1,1) = {['0.12 PLexp - Power law exponent (-)	']};

K(end+1,1) = {['================== Parameters for Uniform wind file [used only for WindType = 2] ============================	']};
K(end+1,1) = {['"none" Filename_Uni - Filename of time series data for uniform wind field. (-)	']};
K(end+1,1) = {['150.0 RefHt_Uni - Reference height for horizontal wind speed (m)	']};
K(end+1,1) = {['240.0 RefLength - Reference length for linear horizontal and vertical sheer (-)	']};

K(end+1,1) = {['================== Parameters for Binary TurbSim Full-Field files [used only for WindType = 3] ==============	']};
K(end+1,1) = {['"' InflowWind.FileName_BTS '"' ' FileName_BTS - Name of the Full field wind file to use (.bts)	']};

K(end+1,1) = {['================== Parameters for Binary Bladed-style Full-Field files [used only for WindType = 4] =========	']};
K(end+1,1) = {['"none" FilenameRoot - Rootname of the full-field wind file to use (.wnd, .sum)	']};
K(end+1,1) = {['False TowerFile - Have tower file (.twr) (flag)	']};

K(end+1,1) = {['================== Parameters for HAWC-format binary files [Only used with WindType = 5] =====================	']};
K(end+1,1) = {['"none" FileName_u - name of the file containing the u-component fluctuating wind (.bin)	']};
K(end+1,1) = {['"none" FileName_v - name of the file containing the v-component fluctuating wind (.bin)	']};
K(end+1,1) = {['"none" FileName_w - name of the file containing the w-component fluctuating wind (.bin)	']};
K(end+1,1) = {['64 nx - number of grids in the x direction (in the 3 files above) (-)	']};
K(end+1,1) = {['32 ny - number of grids in the y direction (in the 3 files above) (-)	']};
K(end+1,1) = {['32 nz - number of grids in the z direction (in the 3 files above) (-)	']};
K(end+1,1) = {['16.0 dx - distance (in meters) between points in the x direction (m)	']};
K(end+1,1) = {['3.0 dy - distance (in meters) between points in the y direction (m)	']};
K(end+1,1) = {['3.0 dz - distance (in meters) between points in the z direction (m)	']};
K(end+1,1) = {['150.0 RefHt_Hawc - reference height; the height (in meters) of the vertical center of the grid (m)	']};

K(end+1,1) = {['------------- Scaling parameters for turbulence ---------------------------------------------------------	']};
K(end+1,1) = {['2 ScaleMethod - Turbulence scaling method [0 = none, 1 = direct scaling, 2 = calculate scaling factor based on a desired standard deviation]	']};
K(end+1,1) = {['1.0 SFx - Turbulence scaling factor for the x direction (-) [ScaleMethod=1]	']};
K(end+1,1) = {['1.0 SFy - Turbulence scaling factor for the y direction (-) [ScaleMethod=1]	']};
K(end+1,1) = {['1.0 SFz - Turbulence scaling factor for the z direction (-) [ScaleMethod=1]	']};
K(end+1,1) = {['1.2 SigmaFx - Turbulence standard deviation to calculate scaling from in x direction (m/s) [ScaleMethod=2]	']};
K(end+1,1) = {['0.8 SigmaFy - Turbulence standard deviation to calculate scaling from in y direction (m/s) [ScaleMethod=2]	']};
K(end+1,1) = {['0.2 SigmaFz - Turbulence standard deviation to calculate scaling from in z direction (m/s) [ScaleMethod=2]	']};

K(end+1,1) = {['------------- Mean wind profile parameters (added to HAWC-format files) ---------------------------------	']};
K(end+1,1) = {['12.0 URef - Mean u-component wind speed at the reference height (m/s)	']};
K(end+1,1) = {['2 WindProfile - Wind profile type (0=constant;1=logarithmic,2=power law)	']};
K(end+1,1) = {['0.2 PLExp_Hawc - Power law exponent (-) (used for PL wind profile type only)	']};
K(end+1,1) = {['0.03 Z0 - Surface roughness length (m) (used for LG wind profile type only)	']};
K(end+1,1) = {['0 XOffset - Initial offset in +x direction (shift of wind box) (-)	']};

K(end+1,1) = {['================== LIDAR Parameters ===========================================================================	']};
K(end+1,1) = {['0 SensorType - Switch for lidar configuration (0 = None, 1 = Single Point Beam(s), 2 = Continuous, 3 = Pulsed)	']};
K(end+1,1) = {['0 NumPulseGate - Number of lidar measurement gates (used when SensorType = 3)	']};
K(end+1,1) = {['30 PulseSpacing - Distance between range gates (m) (used when SensorType = 3)	']};
K(end+1,1) = {['0 NumBeam - Number of lidar measurement beams (0-5)(used when SensorType = 1)	']};
K(end+1,1) = {['-200 FocalDistanceX - Focal distance co-ordinates of the lidar beam in the x direction (relative to hub height) (only first coordinate used for SensorType 2 and 3) (m)	']};
K(end+1,1) = {['0 FocalDistanceY - Focal distance co-ordinates of the lidar beam in the y direction (relative to hub height) (only first coordinate used for SensorType 2 and 3) (m)	']};
K(end+1,1) = {['0 FocalDistanceZ - Focal distance co-ordinates of the lidar beam in the z direction (relative to hub height) (only first coordinate used for SensorType 2 and 3) (m)	']};
K(end+1,1) = {['0.0 0.0 0.0 RotorApexOffsetPos - Offset of the lidar from hub height (m)	']};
K(end+1,1) = {['17 URefLid - Reference average wind speed for the lidar[m/s]	']};
K(end+1,1) = {['0.25 MeasurementInterval - Time between each measurement [s]	']};
K(end+1,1) = {['False LidRadialVel - TRUE => return radial component, FALSE => return "x" direction estimate	']};
K(end+1,1) = {['1 ConsiderHubMotion - Flag whether to consider the hub motion''s impact on Lidar measurements	']};

K(end+1,1) = {['====================== OUTPUT ==================================================	']};
K(end+1,1) = {['False SumPrint - Print summary data to <RootName>.IfW.sum (flag)	']};
K(end+1,1) = {['OutList - The next line(s) contains a list of output parameters. See OutListParameters.xlsx for a listing of available output channels, (-)	']};
K(end+1,1) = {['Wind1VelX	']};
K(end+1,1) = {['Wind1VelY	']};
K(end+1,1) = {['Wind1VelZ	']};
K(end+1,1) = {['END of input file (the word "END" must appear in the first 3 columns of this last OutList line)	']};
K(end+1,1) = {['---------------------------------------------------------------------------------------	']};
writecell(K,InflowWind.FileName,QuoteStrings="none",FileType="text",WriteMode="overwrite");
end