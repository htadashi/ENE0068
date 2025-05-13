% Parâmetros do sinal
fs = 44100;               % Frequência de amostragem (Hz)
t = 0:1/fs:2;             % Duração de 2 segundos
f = 440;                  % Frequência do tom (Hz) — Lá central

% Escolher tipo de entrada: 'seno' ou 'seno_ruido'
tipo_entrada = 'seno_ruido';  % <-- Altere aqui para 'seno' ou 'seno_ruido'

% Gerar sinal de entrada
switch tipo_entrada
    case 'seno'
        x = sin(2*pi*f*t);  % Tom senoidal puro
    case 'seno_ruido'
        x = sin(2*pi*f*t) + 0.3*randn(size(t));  % Tom com ruído branco
    otherwise
        error('Tipo de entrada inválido. Use "seno" ou "seno_ruido".');
end

% Coeficiente do sistema
%a = 0.99999999;
a = 0.9;

% Aplicar o sistema recursivo: y[n] = a*y[n-1] + x[n]
y = filter(1, [1 -a], x);

% Normalização
%x = x / max(abs(x));
%y = y / max(abs(y));

% Tocar o som
disp('Tocando sinal original...');
sound(x, fs);
pause(3);  % Aguarda terminar

disp('Tocando sinal processado...');
sound(y, fs);
pause(3);

% Plot dos sinais
figure;
subplot(2,1,1);
plot(t, x);
title(['Sinal de entrada: ', titulo(tipo_entrada)]);
xlabel('Tempo (s)'); ylabel('Amplitude');

subplot(2,1,2);
plot(t, y);
title(['Sinal processado: y[n] = a y[n-1] + x[n], com a = ', num2str(a)]);
xlabel('Tempo (s)'); ylabel('Amplitude');


function tipo_titulo = titulo(tipo_entrada)
    switch tipo_entrada
        case 'seno'
            tipo_titulo = 'seno';
        case 'seno_ruido'
            tipo_titulo = 'seno com ruido';
        otherwise
            error('Tipo de entrada inválido. Use "seno" ou "seno_ruido".');
    end
end