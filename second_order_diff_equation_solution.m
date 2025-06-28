% MATLAB Script for Solving and Plotting Linear Difference Equation

clc; clear; close all;

%% Coefficients of the difference equation
a1 = -1.2;   % Example coefficient
a0 = 0.32;   % Example coefficient

%% Initial conditions
y_minus1 = 1;  % y[-1] = c1
y_minus2 = 0;  % y[-2] = c2

%% Define the characteristic polynomial
coeffs = [1 a1 a0];  % Corresponds to y[n] + a1*y[n-1] + a0*y[n-2] = 0

%% Find the roots of the characteristic equation
roots_poly = roots(coeffs);

%% Plot the unit circle and the roots
figure;

subplot(2,1,1);
theta = linspace(0, 2*pi, 300);
plot(cos(theta), sin(theta), 'b--', 'LineWidth', 1.5); % Unit circle

hold on;
plot(real(roots_poly), imag(roots_poly), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Roots
grid on;
axis equal;
xlabel('Real Part');
ylabel('Imaginary Part');
title('Unit Circle and Roots of the Characteristic Polynomial');
legend('Unit Circle', 'Roots');

%% Solve the homogeneous difference equation
N = 20;  % Number of samples to compute
y = zeros(1, N+1);  % For n = 0 to N

y(1) = y_minus2;  % y[-2]
y(2) = y_minus1;  % y[-1]

% Recursively compute y[n] for n = 1 to N
for n = 2:(N+2)
    y(n+1) = -a1 * y(n) - a0 * y(n-1);
end

n_values = -2:N;

%% Plot y[n]
subplot(2,1,2);
stem(n_values, y(1:N+3), 'filled', 'r');
grid on;
xlabel('n');
ylabel('y[n]');
title('Solution y[n] of the Difference Equation');

