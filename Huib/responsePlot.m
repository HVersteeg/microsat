% Version 1.0
function responsePlot(responseData, rotmOut, omegaRsOut, mechEnergyOut, mechPowerOut, torqueOut)

    response_data = responseData.Data;
    time_data = responseData.Time;
    torqueOut.Data = torqueOut.Data*1000;
    
    set(0, 'defaultLegendInterpreter','tex');
    set(0, 'defaultAxesTickLabelInterpreter','tex');
    set(0, 'defaultTextInterpreter','tex');
    
    f = figure(2);
    f.Color = [1 1 1];
    clf;
    
    fontSize = 12;

    %% Response plots
    norm_data = zeros(size(response_data));
    performance_data = zeros(5,3);
   
    % Create plots, rsppl = response plot, powpl = power plot,
    % omegapl = omega plot
    rsppl = axes(f, 'Units',            'normalized',...
                 'OuterPosition',    [0 3/4 2/3 2.3/10]);
    
    for i = 1:3
        
        % Normalize data to step response region
        norm_data(:,i) = (1-(response_data(:,i)/response_data(1,i)));
        stepinfo_data = stepinfo(norm_data(:,i),time_data);
 
        % Defines variables that store their respective parameter value
        % 1 = RiseTime, 2 = SettlingTime, 3 = PeakTime
        % 4 = Peak, 5 = Overshoot perc, 6 = SS error, 7 = Nadir pointing error
        performance_data(1,i) = stepinfo_data.RiseTime;
        performance_data(2,i) = stepinfo_data.SettlingTime;
        performance_data(3,i) = stepinfo_data.PeakTime;
        performance_data(4,i) = stepinfo_data.Peak;
        performance_data(5,i) = stepinfo_data.Overshoot;
        performance_data(6,i) = abs(norm_data(end,i)-1);
        performance_data(7,3) = acosd(rotmOut.Data(end,end));
        
        % Create response plot       
        Colour = [ 'r' 'g' 'b'];
        plot(rsppl, time_data, norm_data(:,i), Colour(i), 'LineWidth' ,1.5);
        hold on
        
    end
    
    % Performance graph axis and legend set-up
    %axis([0 time_data(end) -0.1 1.5])
    rsppl.FontSize = fontSize;
    %yticks (0:0.25:1.5)
    %xticks (0:0.5:time_data(end))
    lgd = legend('Z','Y','X','Location','southeast');
    lgd.FontSize = fontSize-4;    
    
    % Plot labels
    %xlabel('Time [s]', 'FontSize',fontSize);
    ylabel('Amplitude', 'FontSize',fontSize);
    grid on
            
    line1 = char(strcat('Response performance'));
    title( {strcat(line1)},'interpreter','tex','FontSize',fontSize)
    
    %% Power plots
    powpl = axes(f, 'Units',            'normalized',...
             'OuterPosition',    [0 2/4 2/3 2.3/10]);
         
    plot(powpl, time_data, -mechPowerOut.Data(:,1), Colour(1), 'LineWidth' ,1.5);
    
    % Performance graph axis and legend set-up
%    axis([0 time_data(end) round((min(mechPowerOut.Data)/100),0)*100 50])
    powpl.FontSize = fontSize;
%    yticks (round((min(mechEnergyOut.Data)/100),0)*100:100:0)
%    xticks (0:0.5:time_data(end))
    lgd = legend('Power','Location','southeast');
    lgd.FontSize = fontSize-4;
    
    % Plot labels
    %xlabel('Time [s]', 'FontSize',fontSize-2);
    ylabel('Watt', 'FontSize',fontSize);
    grid on
            
    line1 = char(strcat('Reaction sphere power'));
    title( {strcat(line1)},'interpreter','tex','FontSize',fontSize)
    
    %% Omega plots
    [M,I] = max(abs(omegaRsOut.Data(:,1)));
    max_omg_x = omegaRsOut.Data(I,1);
    
    [M,I] = max(abs(omegaRsOut.Data(:,2)));
    max_omg_y = omegaRsOut.Data(I,2);
    
    [M,I] = max(abs(omegaRsOut.Data(:,3)));
    max_omg_z = omegaRsOut.Data(I,3);
    
    omegapl = axes(f, 'Units',          'normalized',...
                 'OuterPosition',    [0 1/4 2/3 2.3/10]);
             
    Colour = [ 'b' 'g' 'r'];
    for i = fliplr(1:3)        
        plot(omegapl, time_data, omegaRsOut.Data(:,i), Colour(i), 'LineWidth' ,1.5);
        hold on
    end
    
    % Performance graph axis and legend set-up
%     axis([0 time_data(end) -0.1 1.5])
    omegapl.FontSize = fontSize;
%     yticks (0:0.2:1.5)
    %xticks (0:2:time_data(end))
    lgd = legend('Z','Y','X','Location','southeast');
    lgd.FontSize = fontSize-4;
    
    % Plot labels
    %xlabel('Time [s]', 'FontSize',fontSize);
    ylabel('Rad/s', 'FontSize',fontSize);
    grid on
            
    line1 = strcat('Reaction sphere relative angular velocity \omega');
    title( {strcat(line1)},'interpreter','tex','FontSize',fontSize)

    
    %% Torque plots
    torqpl = axes(f, 'Units',          'normalized',...
                 'OuterPosition',    [0 0/30 2/3 2.3/10]);
             
    Colour = [ 'b' 'g' 'r'];
    for i = fliplr(1:3)        
        plot(torqpl, time_data, torqueOut.Data(:,i), Colour(i), 'LineWidth' ,1.5);
        hold on
    end
    
    % Performance graph axis and legend set-up
%     axis([0 time_data(end) -0.1 1.5])
    torqpl.FontSize = fontSize;
%     yticks (0:0.2:1.5)
    %xticks (0:2:time_data(end))
    lgd = legend('Z','Y','X','Location','southeast');
    lgd.FontSize = fontSize-4;
    
    % Plot labels
    xlabel('Time [s]', 'FontSize',fontSize);
    ylabel('Nmm', 'FontSize',fontSize);
    grid on
            
    line1 = strcat('Reaction sphere generated torque');
    title( {strcat(line1)},'interpreter','tex','FontSize',fontSize)
    
    %% Create table with information
    textString = {...
                '                   Z-angle | Y-angle | X-angle';...
        sprintf('Rise time [s]    :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(1,:));...
        sprintf('Settling time [s]:  %5.2f  |  %5.2f  |  %5.2f ', performance_data(2,:));...
        sprintf('Peak time [s]    :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(3,:));...
        sprintf('Peak [-]         :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(4,:));...
        sprintf('Overshoot [%%]    :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(5,:));...
        sprintf('St.St. error [-] : %5.4f  | %5.4f  | %5.4f ', performance_data(6,:));...
                ' ';...
        sprintf('Nadir pointing error [deg] : %7.4f', performance_data(7,3));...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
        sprintf('Maximum power [W]       : %5.2f', max(abs(mechPowerOut.Data)));...
                ' ';...
        sprintf(strcat('Energy to max' ,{' '},string(char(969)),{' '},'[J]     : %5.2f'), mechEnergyOut.Data(find(mechPowerOut.Data(10:end) > 0, 1)+10));...
                
        sprintf(strcat('Energy to stationary [J]: %5.2f'), (mechEnergyOut.Data(end)-mechEnergyOut.Data(find(mechPowerOut.Data(10:end) > 0, 1)+10)));...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
        sprintf(strcat('Maximum ',{' '},string(char(969)),'-x [Rad/s] : %5.2f'), max_omg_x);...
                
        sprintf(strcat('Maximum ',{' '},string(char(969)),'-y [Rad/s] : %5.2f'), max_omg_y);...
                
        sprintf(strcat('Maximum ',{' '},string(char(969)),'-z [Rad/s] : %5.2f'), max_omg_z);... 
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
        sprintf(strcat('Maximum Torque [Nmm]: %5.2f'), max(vecnorm(torqueOut.Data')));...
                ' ';...
        sprintf(strcat('Maximum T-x [Nmm]   : %5.2f'), max(abs((torqueOut.Data(:,1)))));...
                
        sprintf(strcat('Maximum T-y [Nmm]   : %5.2f'), max(abs((torqueOut.Data(:,2)))));...
                
        sprintf(strcat('Maximum T-z [Nmm]   : %5.2f'), max(abs((torqueOut.Data(:,3)))))};
    
    uicontrol(f,...
                  'FontSize',   fontSize-2,...
                  'Units',      'normalized',...
                  'Style',      'text',...
                  'String',     textString,...
                  'FontName',   'FixedWidth',...
                  'Position',   [0.63 0.05 0.35 9/10],...
                  'BackgroundColor', [1 1 1])
    
    % Fullsize window
    f.Units = 'pixels';
    displaySize = 750;
    f.Position = [0 0 displaySize*sqrt(2) displaySize];
    
    % Fixes position of table for cleaner look
    % t.Position(3:4) = t.Extent(3:4);
    
    % Save figure as PDF for best quality
    pause(0.1)
    saveFolder = 'PlotOutput/ResponsePlot';
    save2pdf(saveFolder,2,600)
    
end