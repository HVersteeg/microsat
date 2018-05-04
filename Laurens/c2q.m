function q = c2q(C)
% Convert rotation matrix C (in vector form) to a quaternion q
% C is a 9x1 vector with elements[Column1; Column2; Column3]
% q is a standard quaternion with the vector part at the start

% Method according to 
%       I.Y. Bar-Itzhack, "New method for extracting the quaternion from a 
%       rotation matrix," Journal of Guidance, Control, and Dynamics, 
%       vol. 23, no. 6, pp. 1085-1087, 2000
% Using basically the same code as rotm2quat from robotics toolbox

% Make rotation matrix from vector C, for more intuitive indexing
R = reshape(C, [3,3]);
% Calculate all elements of symmetric K matrix
K11 = R(1,1) - R(2,2) - R(3,3);
K12 = R(1,2) + R(2,1);
K13 = R(1,3) + R(3,1);
K14 = R(3,2) - R(2,3);

K22 = R(2,2) - R(1,1) - R(3,3);
K23 = R(2,3) + R(3,2);
K24 = R(1,3) - R(3,1);

K33 = R(3,3) - R(1,1) - R(2,2);
K34 = R(2,1) - R(1,2);

K44 = R(1,1) + R(2,2) + R(3,3);

% Construct K matrix according to paper
K = [K11,    K12,    K13,    K14;
     K12,    K22,    K23,    K24;
     K13,    K23,    K33,    K34;
     K14,    K24,    K34,    K44];

K = K ./ 3;
[eigVec, eigVal] = eig(K, 'vector');
[~, maxIndex] = max(real(eigVal));
q = real(eigVec(:,maxIndex));
end