clear; clc;
% Initialize mobile device connection
m = mobiledev;
m.AccelerationSensorEnabled = 1;
m.Logging = 1;

% Low-pass filter parameter
alpha = 0.1;  % Smoothing factor for IIR filter

% Initialize filtered approximation
theta_approx_filtered = 0;

% Create figure and subplots
figure;

% Subplot 1: Raw Accelerations
subplot(4,1,1);
ayPlot = plot(nan, nan, '-g'); hold on;  % Green for Y acceleration
azPlot = plot(nan, nan, '-b');           % Blue for Z acceleration
hold off;
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Accelerometer Readings: a_y and a_z');
legend('a_y', 'a_z');
grid on;

% Subplot 2: Estimated Angle (atan2)
subplot(4,1,2);
thetaPlot = plot(nan, nan, '-k');  % Black for atan2 angle
xlabel('Time (s)');
ylabel('\theta = atan2(a_z, a_y) (rad)');
title('Angle Estimated from Accelerometer');
grid on;

% Subplot 3: Small Angle Approximation
subplot(4,1,3);
thetaApproxPlot = plot(nan, nan, '-m');  % Magenta for small-angle approx
xlabel('Time (s)');
ylabel('\theta \approx a_z / a_y');
title('Small Angle Approximation');
grid on;

% Subplot 4: Low-pass Filtered Approximation
subplot(4,1,4);
thetaApproxFiltPlot = plot(nan, nan, '-r');  % Red for filtered approx
xlabel('Time (s)');
ylabel('Filtered \theta \approx a_z / a_y');
title('Low-pass Filtered Small Angle Approximation');
grid on;

% Data acquisition and plotting loop
for k = 1:200
    pause(0.1);  % Sampling rate ~10 Hz

    [acc, t] = accellog(m);

    if ~isempty(acc)
        elapsedTime = t - t(1);  % Time vector
        a_y = acc(:,2);          % Y-axis acceleration
        a_z = acc(:,3);          % Z-axis acceleration

        % Compute atan2 angle
        theta = atan2(a_z, a_y);

        % Small angle approximation
        theta_approx = a_z ./ a_y;

        % Initialize filtered approximation array
        theta_approx_filtered_array = zeros(size(theta_approx));

        % Apply low-pass filter to small-angle approximation
        for i = 1:length(theta_approx)
            theta_approx_filtered = alpha * theta_approx(i) + (1 - alpha) * theta_approx_filtered;
            theta_approx_filtered_array(i,1) = theta_approx_filtered;
        end

        % Update subplot 1: Raw Accelerations
        subplot(4,1,1);
        set(ayPlot, 'XData', elapsedTime, 'YData', a_y);
        set(azPlot, 'XData', elapsedTime, 'YData', a_z);
        set_xlim(elapsedTime);
        ylim([-20, 20]);

        % Update subplot 2: Estimated Angle
        subplot(4,1,2);
        set(thetaPlot, 'XData', elapsedTime, 'YData', theta);
        set_xlim(elapsedTime);
        ylim([-pi, pi]);

        % Update subplot 3: Small Angle Approximation
        subplot(4,1,3);
        set(thetaApproxPlot, 'XData', elapsedTime, 'YData', theta_approx);
        set_xlim(elapsedTime);
        ylim([-pi, pi]);

        % Update subplot 4: Filtered Small Angle Approximation
        subplot(4,1,4);
        set(thetaApproxFiltPlot, 'XData', elapsedTime, 'YData', theta_approx_filtered_array);
        set_xlim(elapsedTime);
        ylim([-pi, pi]);

        drawnow;
    end
end

% Stop logging after completion
m.Logging = 0;

% Helper function to set safe x-axis limits
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
