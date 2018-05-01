classdef animateAttitude < handle
    
    properties (Access = private)
        timerObj;   % timer for controlling rate of animation & pause/start
        time;       % vector of time data [nx1]
        timeNow;    % current time;
        C;          % matrix containing rows of rotation matrix data [nx9]
        n;          % time index
        nMax;       % length of time vector
        
        % Graphics Handles
        fig;
        ax;
        vectors;
        button;
    end

    methods
        function self = animateAttitude(simout, t_step)
            %ANIMATEATTITUDE Summary of this function goes here
            %   Detailed explanation goes here
            self.timerObj = timer(...
                'ExecutionMode',        'fixedRate',...
                'Period',               t_step,...
                'TimerFcn',             @self.plotNext...
                );
            self.time = simout.Time;
            self.C    = simout.Data;
            self.timeNow = self.time(1);
            self.n    = 1;
            self.nMax = length(self.time);
        end

        function plotInit(self)
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
            
            self.button = uicontrol(...
                'Style',            'togglebutton',...
                'String',           'Start',...
                'Units',            'normalized',...
                'Position',         [0.45 0.05 0.1 0.05],...
                'Callback',         @self.start ...
                );
        end
    end
    
    methods (Access = private)
        % start timer
        function start(self, ~, ~)
            start(self.timerObj);
            self.button.String = 'Pause';
            self.button.Callback = @self.pause;
        end
        
        % pause timer
        function pause(self, ~, ~)
            stop(self.timerObj);
            self.button.String = 'Start';
            self.button.Callback = @self.start;
        end
        
        % advance one timestep
        function plotNext(self, ~, ~)
            % advance to next step
            self.n = self.n+1;
            % enforce max time index
            if self.n > self.nMax
                stop(self.timerObj);
                self.button.String = 'Start';
                self.button.Callback = @self.start;
                self.n = 1; % reset once max time is reached
                return
            end
            
            % update direction of all three vectors
            for ii = 1:3
                jj = 3*(ii-1);
                self.vectors(ii).XData(2) = self.C(self.n, 1+jj);
                self.vectors(ii).YData(2) = self.C(self.n, 2+jj);
                self.vectors(ii).ZData(2) = self.C(self.n, 3+jj);
            end
        end
    end
end