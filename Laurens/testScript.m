

R = eul2rotm([pi/4, pi/7, 0]);
C = reshape(R, [9,1]);

q = ones(4,1);
q(4) = 1/2 * sqrt(C(1) + C(5) + C(9) + 1);
q(1:3) = 1/(4*q(4)) * [C(6)-C(8); C(7)-C(3); C(2)-C(4)];

q_2 = rotm2quat(R);
q_2 = [q_2(2:4)'; q_2(1)];
disp(q)
disp(q_2)
disp(c2q(C))
disp(reshape(q2c(q_2), [3,3])-R)