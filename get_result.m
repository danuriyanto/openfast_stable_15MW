clc; clear; close all;
load("designTable.mat")
addpath generate_openfast_input_seastate/

for sitenum = [2] %:height(designTable) %loop through sites
    clearvars -except designTable sitenum fact
    % set the folder name
    sitename = designTable.Name{sitenum};
    foldername = ['openfast_blade_analysis_' sitename];
    dir_outb = dir(sprintf("%s/*.outb",foldername));
    svfolder = ['fig_moment_' sitename];
    mkdir(svfolder)

    % Pre-allocate structure with the expected number of files
    numFiles = numel(dir_outb);
    outb_result(numFiles) = struct(...
        'Hs', [], 'Vhub', [], 'Tp', [], 'seed', [], ...
        'mudline_moment_history', [], 'maxMoment', 0, ...
        'T_maxMoment_mudline', [], 'seastate_history', [], ...
        'towertop_F_history', [], 'towertop_def_history', []);

    for n = 1:numel(dir_outb)
        n
        FileName = [dir_outb(n).folder '/' dir_outb(n).name];
        [Channels, ChanName, ChanUnit, FileID, DescStr] = ReadFASTbinary(FileName);
        run_info = dir_outb(n).name;
        [info_loc,info_Hs, info_Vhub, info_Tp, info_seed] = get_info(run_info);
        t200 = find(Channels(:,1)==200);

        % base moment
        T = Channels(t200:end,1);
        My = Channels(t200:end,strcmp(ChanName,'-ReactMYss'))*1e-6; %MN.m
        Mx = Channels(t200:end,strcmp(ChanName,'-ReactMXss'))*1e-6; %MN.m
        Mz = Channels(t200:end,strcmp(ChanName,'-ReactMZss'))*1e-6; %MN.m
        Mres = sqrt((Mx.^2 + My.^2));

        % seastate information
        wave_elev = Channels(t200:end,strcmp(ChanName,'Wave1Elev')); %m
        windX = Channels(t200:end,strcmp(ChanName,'Wind1VelX')); %m/s
        windY = Channels(t200:end,strcmp(ChanName,'Wind1VelY')); %m/s
        windZ = Channels(t200:end,strcmp(ChanName,'Wind1VelZ')); %m/s
        seastate_history = table(T,wave_elev,windX,windY,windZ);

        % max base moment (MN.m)
        [maxMoment,iMax] = max(Mres);
        T_maxMoment = T(iMax);
        mudline_moment_history = table(T,My,Mx,Mz,Mres);

        % towertop force (MN)
        towertop_Fx = Channels(t200:end,strcmp(ChanName,'YawBrFxp'))*10^-3; %MN
        towertop_Fy = Channels(t200:end,strcmp(ChanName,'YawBrFyp'))*10^-3; %MN
        towertop_res= sqrt((towertop_Fx.^2 + towertop_Fy.^2));
        towertop_F_history = table(T,towertop_Fx,towertop_Fy,towertop_res);

        % towertop deflection (m)
        towertop_dx = Channels(t200:end,strcmp(ChanName,'YawBrTDxp'));
        towertop_dy = Channels(t200:end,strcmp(ChanName,'YawBrTDyp'));
        towertop_dz = Channels(t200:end,strcmp(ChanName,'YawBrTDzp'));
        towertop_def = table(T,towertop_dx,towertop_dy,towertop_dz);

        %blade root SF and BM (force in MN, moment in MN.m)
        root1_Fx = Channels(t200:end,strcmp(ChanName,'RootFxc1'))/1000;
        root1_Fy = Channels(t200:end,strcmp(ChanName,'RootFyc1'))/1000;
        root1_Mx = Channels(t200:end,strcmp(ChanName,'RootMxc1'))/1000;
        root1_My = Channels(t200:end,strcmp(ChanName,'RootMyc1'))/1000;

        root2_Fx = Channels(t200:end,strcmp(ChanName,'RootFxc2'))/1000;
        root2_Fy = Channels(t200:end,strcmp(ChanName,'RootFyc2'))/1000;
        root2_Mx = Channels(t200:end,strcmp(ChanName,'RootMxc2'))/1000;
        root2_My = Channels(t200:end,strcmp(ChanName,'RootMyc2'))/1000;

        root3_Fx = Channels(t200:end,strcmp(ChanName,'RootFxc3'))/1000;
        root3_Fy = Channels(t200:end,strcmp(ChanName,'RootFyc3'))/1000;
        root3_Mx = Channels(t200:end,strcmp(ChanName,'RootMxc3'))/1000;
        root3_My = Channels(t200:end,strcmp(ChanName,'RootMyc3'))/1000;
        bladeroot = table(T,root1_Fx,root1_Fy,root1_Mx,root1_My, ...
            root2_Fx,root2_Fy,root2_Mx,root2_My, ...
            root3_Fx,root3_Fy,root3_Mx,root3_My);

        outb_result(n).Hs       = info_Hs;
        outb_result(n).Vhub     = info_Vhub;
        outb_result(n).Tp       = info_Tp;
        outb_result(n).seed     = info_seed;
        outb_result(n).mudline_moment_history = mudline_moment_history;
        outb_result(n).T_maxMoment_mudline = T_maxMoment;
        outb_result(n).seastate_history = seastate_history;
        outb_result(n).towertop_F_history = towertop_F_history;
        outb_result(n).towertop_def_history = towertop_def;
        outb_result(n).blade_root = bladeroot;

        %% figure of root moments
        fig_root_profile = figure(Visible="on");
        fig_root_profile.Position = [100 100 1000 1000];
        
        % moment at the root
        subplot(4,3,[1 4])
        Mroot1 = sqrt(outb_result(n).blade_root.root1_My.^2 + outb_result(n).blade_root.root1_Mx.^2); %magnitude
        th_Mroot1 = atan2(outb_result(n).blade_root.root1_My, outb_result(n).blade_root.root1_Mx);
        polarscatter(th_Mroot1,Mroot1,"filled","o",SizeData=3,MarkerFaceAlpha=0.7,MarkerEdgeAlpha=0);
        title('blade root 1 moment - MN.m')

        subplot(4,3,[2 3])
        plot(outb_result(n).blade_root.T,outb_result(n).blade_root.root1_Mx)
        ylabel('Mx - MN.m')

        subplot(4,3,[5 6])
        plot(outb_result(n).blade_root.T,outb_result(n).blade_root.root1_My)
        ylabel('My - MN.m')
        xlabel('Time (s)')
        
        % shear force at the root
        subplot(4,3,[7 10])
        Froot1 = sqrt(outb_result(n).blade_root.root1_Fy.^2 + outb_result(n).blade_root.root1_Fx.^2); %magnitude
        th_Froot1 = atan2(outb_result(n).blade_root.root1_Fy, outb_result(n).blade_root.root1_Fx);
        polarscatter(th_Froot1,Froot1,"filled","o",SizeData=3,MarkerFaceAlpha=0.7,MarkerEdgeAlpha=0);
        title(' blade root 1 shear force - MN')

        subplot(4,3,[8 9 ])
        plot(outb_result(n).blade_root.T,outb_result(n).blade_root.root1_Fx)
        ylabel('in plane SF (Fx) - MN')

        subplot(4,3,[11 12])
        plot(outb_result(n).blade_root.T,outb_result(n).blade_root.root1_Fy)
        ylabel('out plane SF (Fy) - MN')
        xlabel('Time (s)')
        
       
        sgtitle(sprintf('blade root 1 %s Vhub %0.2f (m/s) seed %0.0f',info_loc, info_Vhub, info_seed))
        exportgraphics(fig_root_profile,[svfolder '/' sprintf('blade_profile_Hs_%0.2f_Vhub_%0.2f_seed_%0.0f.png',info_Hs,info_Vhub,info_seed)])


        %% figure of tower response profile
        fig_tower_profile = figure(Visible="on");
        fig_tower_profile.Position = [100 100 1500 1600];

        subplot(6,4, [1 2]) % plot the timehistory of the wave
        plot(outb_result(n).seastate_history.T,outb_result(n).seastate_history.wave_elev, LineWidth = 1 )
        xlabel('Time (s)')
        ylabel('wave elev (m)')

        subplot(6,4, [5 6]) % plot the timehistory of wind in X direction
        plot(outb_result(n).seastate_history.T,outb_result(n).seastate_history.windX, LineWidth = 1 )
        xlabel('Time (s)')
        ylabel('wind X (m)')

        subplot(6,4, [13 14]) % plot the mudline moment SRSS
        plot(outb_result(n).mudline_moment_history.T,outb_result(n).mudline_moment_history.Mres, LineWidth = 1 ,DisplayName='Hs')
        xlabel('Time (s)')
        ylabel('Mudline M_{SRSS} (MN.m)')

        subplot(6,4, [21 22]) % plot the tower top force SRSS
        plot(outb_result(n).towertop_F_history.T,outb_result(n).towertop_F_history.towertop_res)
        xlabel('Time (s)')
        ylabel('Tower-Top Force_{SRSS} (MN)')

        subplot(6,4, [3 4 7 8]) % plot the windX-Y polar
        V = sqrt(outb_result(n).seastate_history.windY.^2 + outb_result(n).seastate_history.windX.^2); %magnitude
        th_V = atan2(outb_result(n).seastate_history.windY, outb_result(n).seastate_history.windX);
        polarscatter(th_V,V,"filled","o",SizeData=3,MarkerFaceAlpha=0.7,MarkerEdgeAlpha=0,DisplayName='wind X-Y polarplot (m/s)');
        ax = gca;
        ax.ThetaDir = 'clockwise'; % Set the direction of increasing angle
        ax.ThetaZeroLocation = 'top'; % Set 0 degrees to the top
        grid on;
        legend(Location="best")

        subplot(6, 4, [11 12 15 16]) % plot the mudline Mx-My
        M = sqrt(outb_result(n).mudline_moment_history.My.^2 + outb_result(n).mudline_moment_history.Mx.^2); %magnitude
        th_M = atan2(outb_result(n).mudline_moment_history.My, outb_result(n).mudline_moment_history.Mx)-pi/2;
        polarscatter(th_M,M,2,"filled","o",SizeData=3,MarkerFaceAlpha=0.7,MarkerEdgeAlpha=0, DisplayName='Mx-My polarplot (MN.m)');
        ax = gca;
        ax.ThetaDir = 'clockwise'; % Set the direction of increasing angle
        ax.ThetaZeroLocation = 'top'; % Set 0 degrees to the top
        legend(Location="best")
        grid on;

        subplot(6,4, [19 20 23 24]) % plot the tower top dx-dy
        d = sqrt(outb_result(n).towertop_def_history.towertop_dx.^2 + outb_result(n).towertop_def_history.towertop_dy   .^2); %magnitude
        th_d = atan2(outb_result(n).towertop_def_history.towertop_dy, outb_result(n).towertop_def_history.towertop_dx);
        polarscatter(th_d,d,2,"filled","o",SizeData=3,MarkerFaceAlpha=0.7,MarkerEdgeAlpha=0, DisplayName='Towertop deflection polarplot (m)');
        ax = gca;
        ax.ThetaDir = 'clockwise'; % Set the direction of increasing angle
        ax.ThetaZeroLocation = 'top'; % Set 0 degrees to the top
        legend(Location="best")
        grid on;

        sgtitle(sprintf('aligned wind %s Hs %0.2f (m) Vhub %0.2f (m/s) seed %0.0f',info_loc,info_Hs, info_Vhub, info_seed))
        exportgraphics(fig_tower_profile,[svfolder '/' sprintf('noyaw_Hs_%0.2f_Vhub_%0.2f_seed_%0.0f.png',info_Hs,info_Vhub,info_seed)])
        close all
        %%
    end

end
