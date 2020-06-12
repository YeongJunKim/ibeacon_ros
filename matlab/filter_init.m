
global FIR_FILTER EKF_FILTER PF_FILTER app
%% CLEAR ALL

% clear all;

%% SET VARIABLES

app.tile_size;
app.tile_num;
app.dt;

%% INITIALIZATION FILTER
% addpath('../../../matlab/filters/FIR');
% addpath('../../../matlab/filters/EKF');
% addpath('../../../matlab/filters/PF');

syms x y theta
syms v_l v_theta
syms x_main y_main
syms x_sub y_sub theta_sub
syms v_l_sub v_theta_sub

a = app.tile_size * app.tile_num;
x1 = 0; y1 = 0;
x2 = 0; y2 = a;
x3 = a; y3 = a;
x4 = a; y4 = 0;
x4 = 1.35; y4 = 0;
% x1 = app.anchor_position(1,1); y1 = app.anchor_position(2,1);
% x2 = app.anchor_position(1,2); y2 = app.anchor_position(2,2);
% x3 = app.anchor_position(1,3); y3 = app.anchor_position(2,3);
% x4 = app.anchor_position(1,4); y4 = app.anchor_position(2,4);



clear f_main
f_main.x(x,y,theta,v_l,v_theta) = x + v_l * cos(theta) * app.dt;
f_main.y(x,y,theta,v_l,v_theta) = y + v_l * sin(theta) * app.dt;
f_main.theta(x,y,theta,v_l,v_theta) = theta + v_theta * app.dt;
f_main = [f_main.x f_main.y f_main.theta]';
Jacobian_F_main = jacobian(f_main,[x,y,theta]);
f_main = matlabFunction(f_main);
Jacobian_F_main = matlabFunction(Jacobian_F_main);

% State of sub robots
clear f_sub
f_sub.x_main(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = x;
f_sub.y_main(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = y;
f_sub.x_sub(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = x_sub + v_l_sub * cos(theta_sub) * app.dt;
f_sub.y_sub(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = y_sub + v_l_sub * sin(theta_sub) * app.dt;
f_sub.theta(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = theta_sub + v_theta_sub * app.dt;
f_sub = [f_sub.x_main f_sub.y_main f_sub.x_sub f_sub.y_sub f_sub.theta]';
Jacobian_F_sub = jacobian(f_sub,[x,y,x_sub,y_sub,theta_sub]);
f_sub = matlabFunction(f_sub);
Jacobian_F_sub = matlabFunction(Jacobian_F_sub);

% Measurement of main robot
clear h_main
h_main.dist1(x,y,theta,v_l,v_theta) = sqrt((x-x1)^2 + (y-y1)^2);
h_main.dist2(x,y,theta,v_l,v_theta) = sqrt((x-x2)^2 + (y-y2)^2);
h_main.dist3(x,y,theta,v_l,v_theta) = sqrt((x-x3)^2 + (y-y3)^2);
h_main.dist4(x,y,theta,v_l,v_theta) = sqrt((x-x4)^2 + (y-y4)^2);
h_main.theta(x,y,theta,v_l,v_theta) = theta;
h_main = [h_main.dist1 h_main.dist2 h_main.dist3 h_main.dist4 h_main.theta]';
Jacobian_H_main = jacobian(h_main,[x,y,theta]);
h_main = matlabFunction(h_main);
Jacobian_H_main = matlabFunction(Jacobian_H_main);

% Measurement of sub robots
clear h_sub
h_sub.x_main(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = x;
h_sub.y_main(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = y;
h_sub.d_x(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = x - x_sub;
h_sub.d_y(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = y - y_sub;
h_sub.theta(x,y,x_sub,y_sub,theta_sub,v_l_sub,v_theta_sub) = theta_sub;
h_sub = [h_sub.x_main h_sub.y_main h_sub.d_x h_sub.d_y h_sub.theta]';
Jacobian_H_sub = jacobian(h_sub,[x,y,x_sub,y_sub,theta_sub]);
h_sub = matlabFunction(h_sub);
Jacobian_H_sub = matlabFunction(Jacobian_H_sub);

for i = 1:3
    FIR_FILTER(i).filter = FIR;
    EKF_FILTER(i).filter = EKF;
    PF_FILTER(i).filter = PF;
end

x_main_hat_FIR = app.init_state1;
% x_sub1_hat_FIR = app.init_state2;
% x_sub2_hat_FIR = app.init_state3;

FIR_init(FIR_FILTER(1).filter, 8, 3, 5, 2, f_main, Jacobian_F_main, h_main, Jacobian_H_main, x_main_hat_FIR);
% FIR_init(FIR_FILTER(2).filter, 8, 5, 5, 2, f_sub, Jacobian_F_sub, h_sub, Jacobian_H_sub, x_sub1_hat_FIR);
% FIR_init(FIR_FILTER(3).filter, 8, 5, 5, 2, f_sub, Jacobian_F_sub, h_sub, Jacobian_H_sub, x_sub2_hat_FIR);

EKF_init(EKF_FILTER(1).filter, eye(3), (blkdiag(0.1, 0.1, 0.1)), (blkdiag(0.2,0.2,0.2,0.2,0.1)), f_main, Jacobian_F_main,h_main, Jacobian_H_main, x_main_hat_FIR);
% EKF_init(EKF_FILTER(2).filter, eye(5), (blkdiag(0.00001, 0.00001, 0.00001, 0.00001, 0.00001)), (blkdiag(0.0001, 0.00001, 0.00001, 0.00001, 0.01)), f_sub, Jacobian_F_sub, h_sub, Jacobian_H_sub, x_sub1_hat_FIR);
% EKF_init(EKF_FILTER(3).filter, eye(5), (blkdiag(0.00001, 0.00001, 0.00001, 0.00001, 0.00001)), (blkdiag(0.0001, 0.00001, 0.00001, 0.00001, 0.01)), f_sub, Jacobian_F_sub, h_sub, Jacobian_H_sub, x_sub2_hat_FIR);

PF_init(PF_FILTER(1).filter, 1, x_main_hat_FIR, 1000, blkdiag(0.1,0.1,0.0), blkdiag(0.1,0.1,0.001), blkdiag(0.02,0.02,0.02,0.02,0.001), f_main, h_main, 'systematic_resampling');
% PF_init(PF_FILTER(2).filter, 100, x_sub1_hat_FIR, app.history_size, blkdiag(0.1,0.1,0.1,0.1,0.01), blkdiag(0.1,0.05,0.03,0.03,0.11), blkdiag(0.05,0.05,0.02,0.02,0.02), f_sub, h_sub, 'systematic_resampling');
% PF_init(PF_FILTER(3).filter, 100, x_sub2_hat_FIR, app.history_size, blkdiag(0.1,0.1,0.1,0.1,0.01), blkdiag(0.1,0.05,0.03,0.03,0.11), blkdiag(0.05,0.05,0.02,0.02,0.02), f_sub, h_sub, 'systematic_resampling');

clear x1 x2 x3 x4 y1 y2 y3 y4













