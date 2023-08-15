clc
clear

H = 30;
Q = 39.9;
nrpm = 400;
N = 69;
nr = 2 * pi * nrpm / 60;

try
    % Call the functions with the appropriate input arguments
  [P, ns, w, r2, d2, r1_new, d1_new, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, height] = SURFACE(H, Q, nr, N);
  [P, ns, w, r2, d2, r1_new, d1_new, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, height] = axialtry(H, Q, nr, N);
 [P, ns, w, r2, d2, r1_new, d1_new, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, theta, rho, height] = velocity_triangle(H, Q, nr, N);
 [P, ns, w, r2, d2, r1_new, d1_new, b1, b2, u1, vw1, vf1, beta1, u2, vf2, beta2, alpha1, vr1, v1, vr2, xx, yy, zz, theta, rho, height] = t(H,Q,nr,N);

   
    [x1, y1, x2, y2, xl, yl, xt, yt] = meri_lines(Q, H, nr, N);
 % [lead_zr, trail_zr, hub_1_zr, hub_2_zr, hub_3_zr, shroud_1_zr, shroud_2_zr, shroud_3_zr] = bladegen(x1, y1, x2, y2, xl, yl, xt, yt);

   
  
catch exception
    % Display any error messages for troubleshooting
    disp(['Error: ', exception.message]);
    disp('Error occurred during function calls.');
end