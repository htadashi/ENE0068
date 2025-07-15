% --- 1. Definição de Parâmetros e Geração do Sinal ---

% T_0: Período do sinal, N_0: Número de amostras
T_0 = 4; 
N_0 = 1024;

% T: Período de amostragem, t: vetor de tempo
T = T_0/N_0; 
t = (0:T:T*(N_0-1))';

% Geração do sinal x(t) = T*exp(-2*t)
x = T*exp(-2*t); 
x(1) = T*(exp(-2*T_0)+1)/2;

% --- 2. Cálculo da Transformada Discreta de Fourier (TDF / DFT) ---

% Calcula a DFT usando a Fast Fourier Transform (FFT)
X_r = fft(x);

% Cria o vetor de frequências para a DFT
r = [-N_0/2:N_0/2-1]'; 
omega_r = r*2*pi/T_0;


% --- 3. Cálculo da Transformada de Fourier analítica para comparação ---

% Cria um vetor de frequências de alta resolução para a TF analítica
omega = linspace(-pi/T, pi/T, 4097); 

% Calcula a TF analítica de e^(-2t), que é 1/(j*omega+2)
% O operador './' é usado para divisão elemento a elemento.
X = 1./(j*omega+2);

% --- 4. Visualização dos Resultados ---
% Cria o primeiro subplot para a magnitude
subplot(211);
% Plota a magnitude da TF verdadeira (linha preta) e da DFT (círculos pretos)
% fftshift é usado para centralizar a frequência zero no gráfico da DFT
plot(omega, abs(X), 'k', omega_r, fftshift(abs(X_r)), 'ko');
xlabel('\omega'); 
ylabel('|X(\omega)|');
axis([-0.01 40 -0.01 0.51]);
legend('FT analítica', ['DFT com T_0 = ', num2str(T_0), ', N_0 = ', num2str(N_0)]);

% Cria o segundo subplot para a fase
subplot(212);
% Plota a fase da TF verdadeira (linha preta) e da DFT (círculos pretos)
plot(omega, angle(X), 'k', omega_r, fftshift(angle(X_r)), 'ko');
xlabel('\omega');
ylabel('\angle X(\omega)');
axis([-0.01 40 -pi/2-0.01 0.01]);
% Adiciona legenda em português, como no original
legend('FT analítica', ['DFT com T_0 = ', num2str(T_0), ', N_0 = ', num2str(N_0)]);