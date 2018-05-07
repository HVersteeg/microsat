clear
syms th1 th2 th3 w1 w2 w3 J1 J2 J3
w = [w1; w2; w3];
th = [th1; th2; th3];
x = [th; w];
A = [1,         0,         -sin(th2);
     0   cos(th1), sin(th1)*cos(th2);
     0, -sin(th1), cos(th1)*cos(th2)];
Ntheta = simplify(inv(A));
Omega  = [  0, -w3,  w2;
           w3,   0, -w1;
          -w2,  w1,   0];
J = diag([J1 J2 J3]);
Q = simplify(-inv(J)*Omega*J*w);

d_dx_Nthetaw = simplify(jacobian(Ntheta*w, x));

ddx_N_theta_omega = [...
      (cos(th1)*w2-sin(th1)*w3)*tan(th2),       (sin(th1)*w2+cos(th1)*w3)/cos(th2)^2, 0, 1, sin(th1)*tan(th2), cos(th1)*tan(th2);...
               -sin(th1)*w2-cos(th1)*w3,                                       0, 0, 0,           cos(th1),         -sin(th1);...
      (cos(th1)*w2-sin(th1)*w3)/cos(th2), (sin(th1)*w2+cos(th1)*w3)*tan(th2)/cos(th2), 0, 0, sin(th1) / cos(th2), cos(th1) / cos(th2)];

N_theta = [...
    1, sin(th1) * tan(th2), cos(th1) * tan(th2);...
    0,           cos(th1),         - sin(th1);...
    0, sin(th1) / cos(th2), cos(th1) / cos(th2)];
