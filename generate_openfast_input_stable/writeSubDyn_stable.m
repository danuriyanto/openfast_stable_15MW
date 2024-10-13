function writeSubDyn_stable(SubDyn)
C(1,1) = {['----------- SubDyn v1.01.x MultiMember Support Structure Input File ------------	']};
C(end+1,1) = {['IEA 15 MW offshore reference model monopile configuration	']};
C(end+1,1) = {['-------------------------- SIMULATION CONTROL ---------------------------------	']};
C(end+1,1) = {['True Echo - Echo input data to "<rootname>.SD.ech" (flag)	']};
C(end+1,1) = {['"DEFAULT" SDdeltaT - Local Integration Step. If "default", the glue-code integration step will be used.	']};
C(end+1,1) = {['3 IntMethod - Integration Method [1/2/3/4 = RK4/AB4/ABM4/AM2].	']};
C(end+1,1) = {['True SttcSolve - Solve dynamics about static equilibrium point	']};
C(end+1,1) = {['False GuyanLoadCorrection - Include extra moment from lever arm at interface and rotate FEM for floating.	']};
C(end+1,1) = {['-------------------- FEA and CRAIG-BAMPTON PARAMETERS---------------------------	']};
C(end+1,1) = {['3 FEMMod - FEM switch: element model in the FEM. [1= Euler-Bernoulli(E-B); 2=Tapered E-B (unavailable); 3= 2-node Timoshenko; 4= 2-node tapered Timoshenko (unavailable)]	']};
C(end+1,1) = {['1 NDiv - Number of sub-elements per member	']};
C(end+1,1) = {['True CBMod - [T/F] If True perform C-B reduction, else full FEM dofs will be retained. If True, select Nmodes to retain in C-B reduced system.	']};
C(end+1,1) = {['0 Nmodes - Number of internal modes to retain (ignored if CBMod=False). If Nmodes=0 --> Guyan Reduction.	']};
C(end+1,1) = {['1 JDampings - Damping Ratios for each retained mode (% of critical) If Nmodes>0, list Nmodes structural damping ratios for each retained mode (% of critical), or a single damping ratio to be applied to all retained modes. (last entered value will be used for all remaining modes).	']};
C(end+1,1) = {['0 GuyanDampMod - Guyan damping {0=none, 1=Rayleigh Damping, 2=user specified 6x6 matrix}.	']};
C(end+1,1) = {['0.0 , 0.0 RayleighDamp - Mass and stiffness proportional damping coefficients (Rayleigh Damping) [only if GuyanDampMod=1].	']};
C(end+1,1) = {['6 GuyanDampSize - Guyan damping matrix (6x6) [only if GuyanDampMod=2].	']};
C(end+1,1) = {['0.0 0.0 0.0 0.0 0.0 0.0	']};
C(end+1,1) = {['0.0 0.0 0.0 0.0 0.0 0.0	']};
C(end+1,1) = {['0.0 0.0 0.0 0.0 0.0 0.0	']};
C(end+1,1) = {['0.0 0.0 0.0 0.0 0.0 0.0	']};
C(end+1,1) = {['0.0 0.0 0.0 0.0 0.0 0.0	']};
C(end+1,1) = {['0.0 0.0 0.0 0.0 0.0 0.0	']};
C(end+1,1) = {['---- STRUCTURE JOINTS: joints connect structure members (~Hydrodyn Input File)---	']};
C(end+1,1) = {['2 NJoints - Number of joints (-)	']};
C(end+1,1) = {['JointID JointXss JointYss JointZss JointType JointDirX JointDirY JointDirZ JointStiff	']};
C(end+1,1) = {['(-) (m) (m) (m) (-) (-) (-) (-) (Nm/rad)	']};
C(end+1,1) = {['1 0.00000 0.00000 ' num2str(SubDyn.Mudline_loc*-1,4) ' 1 0.0 0.0 0.0 0.0 - joint properties at mudline	']};
C(end+1,1) = {['2 0.00000 0.00000 ' num2str(SubDyn.Interface_loc,4) ' 1 0.0 0.0 0.0 0.0 - joint properties at interface 	']};

C(end+1,1) = {['------------------- BASE REACTION JOINTS: 1/0 for Locked/Free DOF @ each Reaction Node ---------------------	']};
C(end+1,1) = {['1 NReact - Number of Joints with reaction forces; be sure to remove all rigid motion DOFs of the structure (else det([K])=[0])	']};
C(end+1,1) = {['RJointID RctTDXss RctTDYss RctTDZss RctRDXss RctRDYss RctRDZss SSIfile [Global Coordinate System]	']};
C(end+1,1) = {['(-) (flag) (flag) (flag) (flag) (flag) (flag) (string)	']};
C(end+1,1) = {['1 1 1 1 1 1 1 ' SubDyn.SSI_File]};

C(end+1,1) = {['------- INTERFACE JOINTS: 1/0 for Locked (to the TP)/Free DOF @each Interface Joint (only Locked-to-TP implemented thus far (=rigid TP)) ---------	']};
C(end+1,1) = {['1 NInterf - Number of interface joints locked to the Transition Piece (TP): be sure to remove all rigid motion dofs	']};
C(end+1,1) = {['IJointID ItfTDXss ItfTDYss ItfTDZss ItfRDXss ItfRDYss ItfRDZss [Global Coordinate System]	']};
C(end+1,1) = {['(-) (flag) (flag) (flag) (flag) (flag) (flag)	']};
C(end+1,1) = {['2 1 1 1 1 1 1	']};

C(end+1,1) = {['----------------------------------- MEMBERS --------------------------------------	']};
C(end+1,1) = {['1 NMembers - Number of frame members	']};
C(end+1,1) = {['MemberID MJointID1 MJointID2 MPropSetID1 MPropSetID2 MType COSMID	']};
C(end+1,1) = {['(-) (-) (-) (-) (-) (-) (-)	']};
C(end+1,1) = {['1 1 2 1 1 1 -1	']};

C(end+1,1) = {['------------------ MEMBER X-SECTION PROPERTY data 1/2 [isotropic material for now: use this table for circular-tubular elements] ------------------------	']};
C(end+1,1) = {['2 NPropSets - Number of structurally unique x-sections (i.e. how many groups of X-sectional properties are utilized throughout all of the members)	']};
C(end+1,1) = {['PropSetID YoungE ShearG MatDens XsecD XsecT	']};
C(end+1,1) = {['(-) (N/m2) (N/m2) (kg/m3) (m) (m)	']};
C(end+1,1) = {['1 210000000000 80770000000 7850 ' num2str(SubDyn.Diameter_Mudline,1) ' ' num2str(SubDyn.Thickness_Mudline,4) ' - member diameter at mudline	']};
C(end+1,1) = {['2 210000000000 80770000000 7850 ' num2str(SubDyn.Diameter_Interface,1) ' ' num2str(SubDyn.Thickness_Interface,4) '  - member diameter at interface	']};

C(end+1,1) = {['------------------ MEMBER X-SECTION PROPERTY data 2/2 [isotropic material for now: use this table if any section other than circular, however provide COSM(i,j) below] ------------------------	']};
C(end+1,1) = {['0 NXPropSets - Number of structurally unique non-circular x-sections (if 0 the following table is ignored)	']};
C(end+1,1) = {['PropSetID YoungE ShearG2 MatDens XsecA XsecAsx XsecAsy XsecJxx XsecJyy XsecJ0	']};
C(end+1,1) = {['(-) (N/m2) (N/m2) (kg/m3) (m2) (m2) (m2) (m4) (m4) (m4)	']};

C(end+1,1) = {['-------------------------- CABLE PROPERTIES -------------------------------------	']};
C(end+1,1) = {['0 NCablePropSets - Number of cable cable properties	']};
C(end+1,1) = {['PropSetID EA MatDens T0	']};
C(end+1,1) = {['(-) (N) (kg/m) (N)	']};
C(end+1,1) = {['----------------------- RIGID LINK PROPERTIES ------------------------------------	']};
C(end+1,1) = {['0 NRigidPropSets - Number of rigid link properties	']};
C(end+1,1) = {['PropSetID MatDens	']};
C(end+1,1) = {['(-) (kg/m)	']};
C(end+1,1) = {['---------------------- MEMBER COSINE MATRICES COSM(i,j) ------------------------	']};
C(end+1,1) = {['0 NCOSMs - Number of unique cosine matrices (i.e., of unique member alignments including principal axis rotations); ignored if NXPropSets=0 or 9999 in any element below	']};
C(end+1,1) = {['COSMID COSM11 COSM12 COSM13 COSM21 COSM22 COSM23 COSM31 COSM32 COSM33	']};
C(end+1,1) = {['(-) (-) (-) (-) (-) (-) (-) (-) (-) (-)	']};

C(end+1,1) = {['------------------------ JOINT ADDITIONAL CONCENTRATED MASSES--------------------------	']};
C(end+1,1) = {['1 NCmass - Number of joints with concentrated masses; Global Coordinate System	']};
C(end+1,1) = {['CMJointID JMass JMXX JMYY JMZZ JMXY JMXZ JMYZ MCGX MCGY MCGZ	']};
C(end+1,1) = {['(-) (kg) (kg*m^2) (kg*m^2) (kg*m^2) (kg*m^2) (kg*m^2) (kg*m^2) (m) (m) (m)	']};
C(end+1,1) = {['2 100000.0 1250000.0 1250000.0 2500000.0 0.0 0.0 0.0 0.0 0.0 0.0	']};

C(end+1,1) = {['---------------------------- OUTPUT: SUMMARY & OUTFILE ------------------------------	']};
C(end+1,1) = {['True SumPrint - Output a Summary File (flag).It contains: matrices K,M and C-B reduced M_BB, M-BM, K_BB, K_MM(OMG^2), PHI_R, PHI_L. It can also contain COSMs if requested.	']};
C(end+1,1) = {['0 OutCBModes - Output Guyan and Craig-Bampton modes {0: No output, 1: JSON output}, (flag)	']};
C(end+1,1) = {['0 OutFEMModes - Output first 30 FEM modes {0: No output, 1: JSON output} (flag)	']};
C(end+1,1) = {['False OutCOSM - Output cosine matrices with the selected output member forces (flag)	']};
C(end+1,1) = {['False OutAll - [T/F] Output all members" end forces	']};
C(end+1,1) = {['2 OutSwtch - [1/2/3] Output requested channels to: 1=<rootname>.SD.out; 2=<rootname>.out (generated by FAST); 3=both files.	']};
C(end+1,1) = {['True TabDelim - Generate a tab-delimited output in the <rootname>.SD.out file	']};
C(end+1,1) = {['1 OutDec - Decimation of output in the <rootname>.SD.out file	']};
C(end+1,1) = {['"ES11.4e2" OutFmt - Output format for numerical results in the <rootname>.SD.out file	']};
C(end+1,1) = {['"A11" OutSFmt - Output format for header strings in the <rootname>.SD.out file	']};

C(end+1,1) = {['------------------------- MEMBER OUTPUT LIST ------------------------------------------	']};
C(end+1,1) = {['1 NMOutputs - Number of members whose forces/displacements/velocities/accelerations will be output (-) [Must be <= 9].	']};
C(end+1,1) = {['MemberID NOutCnt NodeCnt [NOutCnt=how many nodes to get output for [< 10]; NodeCnt are local ordinal numbers from the start of the member, and must be >=1 and <= NDiv+1] If NMOutputs=0 leave blank as well.	']};
C(end+1,1) = {['(-) (-) (-)	']};
C(end+1,1) = {['1 1 1	']};
C(end+1,1) = {['------------------------- SSOutList: The next line(s) contains a list of output parameters that will be output in <rootname>.SD.out or <rootname>.out. ------	']};
C(end+1,1) = {['"-ReactFXss, -ReactFYss, -ReactFZss" - Base reactions: fore-aft shear, side-to-side shear and vertical forces at the mudline.	']};
C(end+1,1) = {['"-ReactMXss, -ReactMYss, -ReactMZss" - Base reactions: side-to-side, fore-aft and yaw moments at the mudline.	']};
C(end+1,1) = {['END of output channels and end of file. (the word "END" must appear in the first 3 columns of this line)	']};
writecell(C,SubDyn.FileName,QuoteStrings="none",FileType="text",WriteMode="overwrite");
end