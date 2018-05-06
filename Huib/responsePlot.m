
function responsePlot(responseData, rotmOut, omegaRsOut, mechEnergyOut, mechPowerOut);

    response_data = responseData.Data;
    time_data = responseData.Time;
    
    set(0, 'defaultLegendInterpreter','tex');
    set(0, 'defaultAxesTickLabelInterpreter','tex');
    set(0, 'defaultTextInterpreter','tex');
    
    f = figure(2);
    f.Color = [1 1 1];
    clf;
    
    %% Response plots
    norm_data = zeros(size(response_data));
    performance_data = zeros(5,3);
   
    % Create plots, rsppl = response plot, powpl = power plot,
    % omegapl = omega plot
    rsppl = axes(f, 'Units',            'normalized',...
                 'OuterPosition',    [0 2/3 2/3 3/10]);
    
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
    axis([0 time_data(end) -0.1 1.5])
    rsppl.FontSize = 18;
    yticks (0:0.2:1.5)
    xticks (0:0.5:time_data(end))
    legend('Z','Y','X','Location','southeast');
    
    
    % Plot labels
    %xlabel('Time [s]', 'FontSize',16);
    ylabel('Amplitude', 'FontSize',16);
    grid on
            
    line1 = char(strcat('Response performance'));
    line2 = char(strcat(' '));
    title( {strcat(line1)},'interpreter','tex','FontSize',18)
    
    %% Power plots
    powpl = axes(f, 'Units',            'normalized',...
             'OuterPosition',    [0 0.35 2/3 3/10]);
         
    plot(powpl, time_data, mechPowerOut.Data(:,1), Colour(1), 'LineWidth' ,1.5);
    
    % Performance graph axis and legend set-up
%     axis([0 time_data(end) round((min(mechPowerOut.Data)/100),0)*100 50])
    powpl.FontSize = 18;
%     yticks (round((min(mechEnergyOut.Data)/100),0)*100:100:0)
    xticks (0:0.5:time_data(end))
    legend('Power','Location','southeast');
    
    % Plot labels
    %xlabel('Time [s]', 'FontSize',16);
    ylabel('Watt', 'FontSize',16);
    grid on
            
    line1 = char(strcat('Reaction sphere power'));
    line2 = char(strcat(' '));
    title( {strcat(line1)},'interpreter','tex','FontSize',18)
    
    %% Omega plots
    omegapl = axes(f, 'Units',          'normalized',...
                 'OuterPosition',    [0 1/30 2/3 3/10]);
             
    Colour = [ 'b' 'g' 'r'];
    for i = fliplr(1:3)        
        plot(omegapl, time_data, omegaRsOut.Data(:,i), Colour(i), 'LineWidth' ,1.5);
        hold on
    end
    
    % Performance graph axis and legend set-up
%     axis([0 time_data(end) -0.1 1.5])
    omegapl.FontSize = 18;
%     yticks (0:0.2:1.5)
    xticks (0:0.5:time_data(end))
    legend('Z','Y','X','Location','southeast');
    
    % Plot labels
    xlabel('Time [s]', 'FontSize',16);
    ylabel('Degrees', 'FontSize',16);
    grid on
            
    line1 = strcat('Reaction sphere relative \omega angles');
    line2 = char(strcat(' '));
    title( {strcat(line1)},'interpreter','tex','FontSize',18)
    
    
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
        sprintf('Nadir pointing error [deg] : %5.2f', performance_data(7,3));...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
        sprintf('Maximum power [W] : %5.2f', max(mechPowerOut.Data));...
                ' ';...
        sprintf('Total energy [W]  : %7.2f', mechEnergyOut.Data(end));...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
                ' ';...
        sprintf(strcat('Maximum ',{' '},string(char(969)),'-x [deg] : %5.2f'), min(omegaRsOut.Data(:,1)));...
                ' ';...
        sprintf(strcat('Maximum ',{' '},string(char(969)),'-y [deg] : %5.2f'), min(omegaRsOut.Data(:,2)));...
                ' ';...
        sprintf(strcat('Maximum ',{' '},string(char(969)),'-z [deg] : %5.2f'), min(omegaRsOut.Data(:,3)))};
    
    uicontrol(f,...
                  'FontSize',   14,...
                  'Units',      'normalized',...
                  'Style',      'text',...
                  'String',     textString,...
                  'FontName',   'FixedWidth',...
                  'Position',   [2/3 0 1/3 9/10],...
                  'BackgroundColor', [1 1 1])
    
    % Fullsize window
    f.Units = 'normalized';
    f.OuterPosition = [0 0 1 1];
    
    % Fixes position of table for cleaner look
    % t.Position(3:4) = t.Extent(3:4);
    
    % Save figure as PDF for best quality
    pause(0.1)
    saveFolder = '../Laurens/PlotOutput/ResponsePlot';
    save2pdf(saveFolder,2,600)
    
end