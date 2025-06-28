% (C) Copyright 2025 Hugo Tadashi
% This script uses a mobile device's gyroscope to estimate angles
% using numerical integration and a high-pass filter.


clear; clc;
m = mobiledev;
m.AngularVelocitySensorEnabled = 1;
m.Logging = 1;

figure;

% Subplot 1: X-axis Angular Velocity
subplot(3,1,1);
hx = plot(nan, nan, '-r');  % Red line for X angular velocity
xlabel('Time (s)');
ylabel('\omega_x (rad/s)');
title('X-axis Angular Velocity');
grid on;

% Subplot 2: Integrated Orientation Angle
subplot(3,1,2);
thetaPlot = plot(nan, nan, '-k');  % Black line for integrated angle
xlabel('Time (s)');
ylabel('\theta_x (rad)');
title('Integrated Angle (Dead Reckoning)');
grid on;

% Subplot 3: High-pass filtered Integrated Angle
subplot(3,1,3);
thetaHPPlot = plot(nan, nan, '-b');  % Blue line for high-pass filtered angle
xlabel('Time (s)');
ylabel('\theta_{HP} (rad)');
title('High-pass Filtered Integrated Angle');
grid on;

alpha = 0.95;  % High-pass filter coefficient
thetaHP = 0;   % Initialize filtered angle

for k = 1:100
    pause(0.1);  % Sampling rate ~10 Hz

    [av, t] = angvellog(m);

    if ~isempty(av)
        elapsedTime = t - t(1);  % Time vector
        omega_x = av(:,1);       % X-axis angular velocity

        if numel(elapsedTime) >= 2
            % Numerical integration using trapezoidal rule
            theta_x = cumtrapz(elapsedTime, omega_x); % Integrated angle

            % High-pass filter: simple recursive implementation
            thetaHP = zeros(size(theta_x));
            for n = 2:length(theta_x)
                thetaHP(n) = alpha * (thetaHP(n-1) + theta_x(n) - theta_x(n-1));
            end

            % Update plots
            subplot(3,1,1);
            set(hx, 'XData', elapsedTime, 'YData', omega_x);
            xlim([max(elapsedTime(end)-10,0), elapsedTime(end)]);
            ylim([-20, 20]);

            subplot(3,1,2);
            set(thetaPlot, 'XData', elapsedTime, 'YData', theta_x);
            xlim([max(elapsedTime(end)-10,0), elapsedTime(end)]);

            subplot(3,1,3);
            set(thetaHPPlot, 'XData', elapsedTime, 'YData', thetaHP);
            xlim([max(elapsedTime(end)-10,0), elapsedTime(end)]);

        else
            % Only 1 sample: plot it as a single point
            subplot(3,1,1);
            set(hx, 'XData', elapsedTime, 'YData', omega_x);
            xlim([0, 1]);
            ylim([-20, 20]);

            subplot(3,1,2);
            set(thetaPlot, 'XData', elapsedTime, 'YData', 0);
            xlim([0, 1]);

            subplot(3,1,3);
            set(thetaHPPlot, 'XData', elapsedTime, 'YData', 0);
            xlim([0, 1]);
        end

        drawnow;
    end
end

m.Logging = 0;  % Stop logging when done
