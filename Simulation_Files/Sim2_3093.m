% Constants
analog_frequency = 30.76;  % Frequency of the analog sine wave in Hz
duration = 1;             % Duration of the signal in seconds
num_cycles = 10;          % Number of cycles for part 2
sampling_rates = [1000, 200, 50, 33.33, 28.57];  % Sampling rates in Hz

% Time vector for 1 kHz sampling rate
t_1kHz = linspace(0, duration, duration * sampling_rates(1));

% 1) Generate the digital signal for 1 kHz sampling rate
digital_signal_1kHz = sin(2 * pi * analog_frequency * t_1kHz);

% Plot for Question 1
figure;
subplot(length(sampling_rates), 1, 1);
plot(t_1kHz, digital_signal_1kHz);
title('Digital Signal (1 kHz)');
xlabel('Time (s)');
ylabel('Amplitude');

% Loop through the other sampling rates
for i = 2:length(sampling_rates)
    % Generate the digital signal for the current sampling rate
    t_custom = linspace(0, num_cycles / analog_frequency, num_cycles * sampling_rates(i));
    digital_signal_custom = sin(2 * pi * analog_frequency * t_custom);
    
    % Plot for the current question
    subplot(length(sampling_rates), 1, i);
    plot(t_custom, digital_signal_custom);
    title(['Digital Signal (10 Cycles, ' num2str(sampling_rates(i)) ' Hz)']);
    xlabel('Time (s)');
    ylabel('Amplitude');
end
