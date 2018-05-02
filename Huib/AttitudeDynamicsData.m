%% Attitude Dynamics simulation Parameters
load('MPCfile')

% initial conditions
eulAngles =[70.5 145.6 20.5]*pi/180; %[22.9 11.0 14.1]*pi/180;
q_zero = eul2quat(eulAngles, 'ZYX'); % start quaternion
q_zero = [q_zero(2:4), q_zero(1)];
w_zero = [0 0 0]; % initial angular velocity

% Constant disturbance torques
T_disturb = ones(1,3) * 0.1E-3;

% Inertia data for Satellite & reaction sphere
J_sat = [2.5 2.5 2.5];          % [kg*m^2] satellite xx-yy-zz moments of inertia
J_sphere = 0.005567928416632;	% [kg*m^2] reaction sphere moment of inertia

% satellite single axis rotation transfer function
s = tf('s');
H = 1 / (J_sat(1)*s^2);


%% 3-Axis PID controller gains
PID_B = struct( ...
    'P', 2,     ...
    'I', 0.0002,...
    'D', 5      ...
    );

%% Euler angle setpoint timeseries
timeA = [0;
         50;
         100;
         150;
         200];
rng(123456); % seed random number generator for always the same 'random' values
dataA = [0 0 0;
         45 135 90;
         40 60  70;
         randi([-180 180], 1, 3);
         0 0 0];
eulerSetpoints = timeseries(dataA, timeA);