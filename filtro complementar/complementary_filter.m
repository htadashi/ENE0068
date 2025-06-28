% (C) Copyright 2025 Hugo Tadashi
% This script uses a mobile device's accelerometer and gyroscope
% to estimate angles using a complementary filter.

clear; clc;

% Initialize mobile device
m = mobiledev;
m.AccelerationSensorEnabled = 1;
m.AngularVelocitySensorEnabled = 1;
m.Logging = 1;

% Complementary filter parameter
alpha = 0.98;  % High trust in gyro, low in accel

% Initialize variables
theta_cf = 0;    % Complementary filter estimate
theta_gyro = 0;  % Gyroscope integrated angle

theta_cf_array = [];
theta_gyro_array = [];
theta_acc_array = [];
elapsedTime = [];
prevTime = [];

% Plot initialization
figure;

% Subplot 1: Gyroscope Integrated Angle
subplot(3,1,1);
thetaGyroPlot = plot(nan, nan, '-b');
xlabel('Time (s)');
ylabel('\theta_{gyro} (rad)');
title('Gyroscope Integrated Angle');
grid on;

% Subplot 2: Accelerometer Estimated Angle
subplot(3,1,2);
thetaAccPlot = plot(nan, nan, '-g');
xlabel('Time (s)');
ylabel('\theta_{acc} (rad)');
title('Accelerometer Estimated Angle');
grid on;

% Subplot 3: Complementary Filtered Angle
subplot(3,1,3);
thetaCFPlot = plot(nan, nan, '-r');
xlabel('Time (s)');
ylabel('\theta_{CF} (rad)');
title('Complementary Filtered Angle');
grid on;

for k = 1:500
    pause(0.1);  % Sampling ~10 Hz
    
    [acc, t_acc] = accellog(m);
    [av, t_gyro] = angvellog(m);
    
    if ~isempty(acc) && ~isempty(av)
        % Use latest timestamp for time sync
        t_now = max(t_acc(end), t_gyro(end));
        
        if isempty(prevTime)
            dt = 0.1;  % First iteration: assume 0.1s
        else
            dt = t_now - prevTime;
        end
        prevTime = t_now;
        
        % Latest accelerometer reading
        a_y = acc(end,2);
        a_z = acc(end,3);
        
        % Latest gyroscope X-axis angular velocity
        omega_x = av(end,1);
        
        % Accelerometer angle estimate
        theta_acc = atan2(a_z, a_y);
        
        % Gyroscope integration
        theta_gyro = theta_gyro + omega_x * dt;
        
        % Complementary filter
        theta_cf = alpha * (theta_cf + omega_x * dt) + (1 - alpha) * theta_acc;
        
        % Update arrays
        elapsedTime = [elapsedTime; t_now - t_acc(1)];
        theta_gyro_array = [theta_gyro_array; theta_gyro];
        theta_acc_array = [theta_acc_array; theta_acc];
        theta_cf_array = [theta_cf_array; theta_cf];
        
        % Update plots
        subplot(3,1,1);
        set(thetaGyroPlot, 'XData', elapsedTime, 'YData', theta_gyro_array);
        set_xlim(elapsedTime);
        ylim([-pi, pi]);
        
        subplot(3,1,2);
        set(thetaAccPlot, 'XData', elapsedTime, 'YData', theta_acc_array);
        set_xlim(elapsedTime);
        ylim([-pi, pi]);
        
        subplot(3,1,3);
        set(thetaCFPlot, 'XData', elapsedTime, 'YData', theta_cf_array);
        set_xlim(elapsedTime);
        ylim([-pi, pi]);
        
        drawnow;
    end
end

m.Logging = 0;

% Helper function for safe x-axis limits
function set_xlim(elapsedTime)
    if numel(elapsedTime) >= 2
        x_lower = max(elapsedTime(end) - 10, 0);
        x_upper = elapsedTime(end);
    else
        x_lower = 0;
        x_upper = 1;
    end
    xlim([x_lower, x_upper]);
end
