function responsePlot(response_data, time_data, rotmOut)

    set(0, 'defaultLegendInterpreter','latex');
    set(0, 'defaultAxesTickLabelInterpreter','latex');
    set(0, 'defaultTextInterpreter','latex');
    f = figure(2);
    f.Color = [1 1 1];
    clf;
    
    norm_data = zeros(size(response_data));
    performance_data = zeros(5,3);
   
    % Create plots
    ax = axes(f, 'Units',            'normalized',...
                 'OuterPosition',    [0 0 2/3 1]);
             
    % Loop for all 3 axis, x - y - z
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
        performance_data(7,3) = acosd(rotmOut(end,end));
        
        % Create response plot       
        Colour = [ 'r' 'g' 'b'];
        plot(ax, time_data, norm_data(:,i), Colour(i), 'LineWidth' ,1.5);
        hold on
        
    end
    textString = {...
                '                   Z-angle | Y-angle | X-angle';...
        sprintf('Rise time [s]    :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(1,:));...
        sprintf('Settling time [s]:  %5.2f  |  %5.2f  |  %5.2f ', performance_data(2,:));...
        sprintf('Peak time [s]    :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(3,:));...
        sprintf('Peak [-]         :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(4,:));...
        sprintf('Overshoot [%%]    :  %5.2f  |  %5.2f  |  %5.2f ', performance_data(5,:));...
        sprintf('St.St. error [-] : %5.4f  | %5.4f  | %5.4f ', performance_data(6,:));...
                ' ';...
        sprintf('Nadir pointing error [deg] : %5.2f', performance_data(7,3))};
    
    uicontrol(f,...
                  'FontSize',   14,...
                  'Units',      'normalized',...
                  'Style',      'text',...
                  'String',     textString,...
                  'FontName',   'FixedWidth',...
                  'Position',   [2/3 0.4 1/3 0.5],...
                  'BackgroundColor', [1 1 1])
    
    % Performance graph axis and legend set-up
    axis([0 time_data(end) -0.1 1.5])
    ax.FontSize = 18;
    yticks (-0.1:0.1:1.5)
    xticks (0:1:time_data(end))
    legend('Z','Y','X');
    
    % Plot labels
    xlabel('Time [s]', 'FontSize',16);
    ylabel('Amplitude', 'FontSize',16);
    grid on
            
    line1 = char(strcat('Response performance'));
    line2 = char(strcat(' '));
    title( {strcat(line1)},'interpreter','latex','FontSize',18)
    
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