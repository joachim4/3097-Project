%Question 1
% Define the parameters
fs = 1000;              % Set frequency for sampling (1 kHz)
t = 0:1/fs:1-1/fs;     % Time vector
f = 30.76;              % Frequency in Hertz
A = 1;                  % Amplitude

% Digital signal
sig = A * sin(2*pi*f*t);

% Plot dig signal
plot(t, sig);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave');
grid on;



%Question 2
% Define the parameters
fs = 1000;              % Sampling freq
t1 = 0:1/fs:1-1/fs;     % Time vector 
t2 = 0:1/fs:(10*(1/f))-1/fs; % 10 cycles

f = 30.76;              % Frequency in Hz
A = 1;                  % Amplitude
% Dig signal
x1 = A * sin(2*pi*f*t1);

% 10 cycle dig signal
x2 = A * sin(2*pi*f*t2);

% Figure for stacked plots
figure;

% Plot for second duration
subplot(2, 1, 1);
plot(t1, x1);
xlabel('Time (s)');
ylabel('Amplitude');
title('Digital Sinusoid Signal versus Time');
grid on;

% Plot 10 cycles duration
subplot(2, 1, 2);
plot(t2, x2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sampled sinusoid 1st 10 cycles');
grid on;

%Question 3
fs = 200;               % Sampling freq
t1 = 0:1/fs:1-1/fs;     % Time vector 
t2 = 0:1/fs:(10*(1/f))-1/fs; % 10 cycles 

f = 30.76;              % Frequency in Hz
A = 1;                  % Amplitude

% Dig sig
x1 = A * sin(2*pi*f*t1);

% Generate the digital signal for 10 cycles
x2 = A * sin(2*pi*f*t2);

figure;

% Plot 1s duration
subplot(2, 1, 1);
plot(t1, x1);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (1 Second at 200 Hz)');
grid on;

% Plot 10 cycles
subplot(2, 1, 2);
plot(t2, x2);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (10 Cycles at 200 Hz)');
grid on;

%Question 4 -- 50 Hz sampling rate signal 
fs = 50;                % Sampling freq
t1 = 0:1/fs:1-1/fs;     % Time vector
t2 = 0:1/fs:(10*(1/f))-1/fs; % 10 cycle time 

f = 30.76;              % Frequency 
A = 1;                  % Amplitude

% Dig sig
x1 = A * sin(2*pi*f*t1);

% 10 cycles
x2 = A * sin(2*pi*f*t2);

figure;

% Plot 1s duration
subplot(2, 1, 1);
plot(t1, x1);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (1 Second at 50 Hz)');
grid on;

% Plot 10 cycles
subplot(2, 1, 2);
plot(t2, x2);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (10 Cycles at 50 Hz)');
grid on;

%Question 4 -- 33.33 Hz sampling rate signal
fs = 33.33;             % Sampling freq
t1 = 0:1/fs:1-1/fs;     % Time vector 
t2 = 0:1/fs:(10*(1/f))-1/fs; % 10 cycles vector

f = 30.76;              % Frequency 
A = 1;                  % Amplitude

% Dig sig
x1 = A * sin(2*pi*f*t1);

% 10 cycles sig
x2 = A * sin(2*pi*f*t2);


figure;


subplot(2, 1, 1);
plot(t1, x1);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (1 Second at 33.33 Hz)');
grid on;


subplot(2, 1, 2);
plot(t2, x2);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (10 Cycles at 33.33 Hz)');
grid on;

%Question 4 -- 28.57 Hz sampling rate signal
fs = 28.57;             % Sampling freq
t1 = 0:1/fs:1-1/fs;     % Time vector
t2 = 0:1/fs:(10*(1/f))-1/fs; % 10 cycles vector

f = 30.76;              % Frequency 
A = 1;                  % Amplitude


x1 = A * sin(2*pi*f*t1);
x2 = A * sin(2*pi*f*t2);

figure;

subplot(2, 1, 1);
plot(t1, x1);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (1 Second at 28.57 Hz)');
grid on;

subplot(2, 1, 2);
plot(t2, x2);
xlabel('time');
ylabel('Amplitude');
title('Digital Signal of a Sine Wave (10 Cycles at 28.57 Hz)');
grid on;
