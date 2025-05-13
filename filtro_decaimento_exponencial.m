% Parâmetros
N = 10  ;           % Número de amostras
a = 0.9;           % Coeficiente do filtro
n = 0:N-1;         % Vetor de tempo discreto

% Sinais de entrada
x1 = ones(1, N);                            % Degrau unitário
x2 = x1 + 0.2*randn(1, N);                  % Degrau + ruído branco
x3 = sin(2*pi*0.05*n);                      % Senoide
x4 = x3 + 0.2*randn(1, N);                  % Senoide + ruído branco

% Executar animações para os quatro sinais
%animate_filter(x1, a, N, 'Degrau Unitário');
%animate_filter(x2, a, N, 'Degrau + Ruído Branco');
%animate_filter(x3, a, N, 'Senoide');
animate_filter(x4, a, N, 'Senoide + Ruído Branco');

function animate_filter(x, a, N, title_suffix)
    y = zeros(1, N);

    figure('Name', title_suffix, 'NumberTitle', 'off');
    for i = 2:N
        % Atualiza saída do filtro
        y(i) = a * y(i-1) + x(i);

        % Vetor de tempo correspondente
        n_plot = 0:i-1;

        % Plota entrada
        subplot(2,1,1);
        plot(n_plot, x(1:i), 'b');
        title(['Entrada - ' title_suffix]);
        xlabel('n'); ylabel('x[n]');
        %axis([0 N -2 2]); 
        grid on;

        % Plota saída
        subplot(2,1,2);
        plot(n_plot, y(1:i), 'r');
        title(['Saída do Filtro - ' title_suffix]);
        xlabel('n'); ylabel('y[n]');
        %axis([0 N -2 2]);
        grid on;

        pause(0.025);  % Tempo entre quadros
    end
end


