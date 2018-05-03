classdef animateAttitude < handle
    
    properties (Access = private)
        timerObj;   % timer for controlling rate of animation & pause/start
        time;       % vector of time data [nx1]
        timeNow;    % current time;
        C;          % matrix containing rows of rotation matrix data [nx9]
        t;          % time index
        tMax;       % length of time vector
        tStep;      % time step of the base animation timer
        pace = 1;   % factor with which to speed up / slow down playback time
        
        % Graphics Handles
        fig;
        ax;
        vectors;
        startButton;
        timeSlider;
        paceSelect;
        timeText;
    end

    methods
        function self = animateAttitude(simout, tStep)
            %ANIMATEATTITUDE Summary of this function goes here
            %   Detailed explanation goes here
            self.timerObj = timer(...
                'ExecutionMode',        'fixedRate',...
                'Period',               tStep,...
                'TimerFcn',             @self.advanceTime...
                );
            self.time = simout.Time;
            self.C    = simout.Data;
            self.timeNow = self.time(1);
            self.tStep = tStep;
            self.t     = 0;
            self.tMax  = self.time(end);
        end

        function plotInit(self)
            % close possible other instances of same figure
            hFigTemp = findobj(...
                'Type', 'Figure',...
                'Name', 'Attitude');
            if ~isempty(hFigTemp)
                close(hFigTemp)
            end
            
            self.fig = figure(...
                'NumberTitle',          'off',...
                'Name',                 'Attitude'...
                );
            self.ax = axes('Parent', self.fig,...
                'XLim',                 [-1.5 1.5], ...
                'YLim',                 [-1.5 1.5], ...
                'ZLim',                 [-1.5 1.5], ...
                'Projection',           'perspective',...
                'CameraPosition',       [20 20 20]...
                );
            xlabel('x'); ylabel('y'); zlabel('z');
            hold on
            self.vectors = gobjects(1,3); % initialize vector of graphics objects
            colorVec = 'rgb';
            for ii = 1:3
                jj = 3*(ii-1);
                self.vectors(ii) = plot3(...
                    [0 self.C(1, 1+jj)], ...
                    [0 self.C(1, 2+jj)], ...
                    [0 self.C(1, 3+jj)], ...
                    colorVec(ii),...
                    'LineWidth',        2 ...
                    );
            end
            
            self.startButton = uicontrol(...
                'Style',            'togglebutton',...
                'String',           'Start',...
                'Units',            'normalized',...
                'Position',         [0 0.02 0.1 0.05],...
                'Callback',         @self.start ...
                );
            self.timeSlider = uicontrol(...
                'Style',            'slider',...
                'Min',              0,...
                'Max',              self.tMax,...
                'Value',            0,...
                'Units',            'normalized',...
                'SliderStep',       [1E-3 1E-3],...
                'Position',         [0.1 0.02 0.8 0.05] ...
                );
            addlistener(self.timeSlider , 'Value', 'PostSet', ...
                    @self.updateTimeSlider)
            self.paceSelect = uicontrol(...
                'Style',            'popupmenu',...
                'String',           {'1/4', '1/2', '1', '2', '4', '8', '16'},...
                'Value',            3,...
                'Units',            'normalized',...
                'Position',         [0.9 0.02 0.1 0.05],...
                'Callback',         @self.setPace ...
                );
            self.timeText = uicontrol(...
                'Style',            'text',...
                'String',           't = 000.000',...
                'Units',            'normalized',...
                'Position',         [0 0.93 0.2 0.05] ...
                );
        end
    end
    
    methods (Access = private)
        % start timer
        function start(self, ~, ~)
            if self.t == self.tMax
                return
            end
            start(self.timerObj);
            self.startButton.String = 'Pause';
            self.startButton.Callback = @self.pause;
        end
        
        % pause timer
        function pause(self, ~, ~)
            stop(self.timerObj);
            self.startButton.String = 'Start';
            self.startButton.Callback = @self.start;
        end
        
        % advance one timestep with timer
        function advanceTime(self, ~, ~)
            self.t = self.t + self.tStep * self.pace;
            if self.t >= self.tMax
                self.t = self.tMax;
                stop(self.timerObj);
                self.startButton.String = 'Start';
                self.startButton.Callback = @self.start;
            end
            % update UI elements
            self.updatePlot;
            self.timeSlider.Value = self.t;
        end
        
        % update displayed time and relevant ui figures/elements
        function updatePlot(self)
            self.timeText.String = sprintf('t = %07.3f', self.t);
            Cnow = interp1(self.time, self.C, self.t);
            % update direction of all three vectors
            for ii = 1:3
                jj = 3*(ii-1);
                self.vectors(ii).XData(2) = Cnow(1+jj);
                self.vectors(ii).YData(2) = Cnow(2+jj);
                self.vectors(ii).ZData(2) = Cnow(3+jj);
            end
        end
        
        % continuously updating of ui elements while dragging slider
        function updateTimeSlider(self, ~, eventdata)
            % update time while sliding
            self.t = eventdata.AffectedObject.Value;
            self.updatePlot;
        end
        
        function setPace(self, ~, ~)
            self.pace = 2 ^ (self.paceSelect.Value - 3);
        end
    end
end