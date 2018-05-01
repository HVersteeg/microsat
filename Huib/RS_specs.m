%% parameters from rossini 

H_max = 1.86;       % [Nms] max total angular momentum of sphere at max RPM
speed_max = 3190;   % [RPM] max angular velocity magnitude

%% 

speed_max = speed_max * 2*pi/60; % [rad/s] from [rpm]
J_sphere = H_max/speed_max; % [kg*m^2] moment of inertia of reaction sphere
