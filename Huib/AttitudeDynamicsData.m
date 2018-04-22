%% Attitude Dynamics simulation Parameters
load('MPCfile')

% initial conditions
eulAngles = [22.9 11.0 14.1]*pi/180;
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
