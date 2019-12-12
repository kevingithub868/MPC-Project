%% Init
Ts = 1/5;
quad = Quad(Ts);
[xs, us] = quad.trim();
sys = quad.linearize(xs, us);
[sys_x, sys_y, sys_z, sys_yaw] = quad.decompose(sys, xs, us);

% Design MPC controller
mpc_x = MPC_Control_x(sys_x, Ts);
mpc_y = MPC_Control_y(sys_y, Ts);
mpc_z = MPC_Control_z(sys_z, Ts);
mpc_yaw = MPC_Control_yaw(sys_yaw, Ts);

%% Simulate the systems
[x, t_x, x_x] = lsim_mpc(sys_x, mpc_x, [0 0 0 2], 8, Ts, 10);
[y, t_y] = lsim_mpc(sys_y, mpc_y, [0 0 0 2], 8, Ts, 10);
[z, t_z] = lsim_mpc(sys_z, mpc_z, [0 2], 8, Ts, 10);
[yaw, t_yaw] = lsim_mpc(sys_yaw, mpc_yaw, [0 pi/4], 8, Ts, 10);

%% Plot
figure
subplot(2, 1, 1)
hold on
line([t_x(1) t_x(end)], [0 0], 'Color', 'Black')
p = plot(t_x, x_x(3:4,:));
grid on
title('Position and Velocity')
xlabel('Time [s]')
ylabel('Position [m] / Velocity [m/s]')
legend(p, 'Velocity', 'Position')

subplot(2, 1, 2)
hold on
line([t_x(1) t_x(end)], [0 0], 'Color', 'Black')
p = plot(t_x, x_x(1:2,:));
grid on
title({''; 'Pitch and Pitch-Rate'})
xlabel('Time [s]')
ylabel('Pitch [rad] / Pitch-Rate [rad/s]')
legend(p, 'Pitch-Rate', 'Pitch')