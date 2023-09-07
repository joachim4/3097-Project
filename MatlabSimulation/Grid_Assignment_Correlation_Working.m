%Remove previous data
clear; clc; close all;

% Constants
c = 343; % Speed of sound in m/s
f = 440; % Frequency of source in Hz
Fs = 44100; % Sampling rate in Hz
duration = 0.1; % Duration of the signal in seconds

% Microphone positions
mic = [0, 0;      % Mic 1
       0.8, 0;    % Mic 2
       0, 0.5;    % Mic 3
       0.8, 0.5]; % Mic 4

% Simulated source position (for example, [0.4, 0.3])
source_x = rand()*0.8;
source_y = rand()*0.5;
source = [source_x,source_y];

   hchirp = dsp.Chirp( ...
    'InitialFrequency', 0,...
    'TargetFrequency', 10, ...
    'TargetTime', 10, ...
    'SweepTime', 100, ...
    'SampleRate', 50, ...
    'SamplesPerFrame', 500);

   chirpData = (step(hchirp))';
evenFlag = mod(minute(datetime('now')),2);
if evenFlag
    chirpData = fliplr(chirpData);
end

signal = chirpData;


t = (0:1/Fs:(length(signal) - 1) / Fs);

% Compute distances from the source to each microphone
d = sqrt(sum((mic - [source_x, source_y]).^2, 2));

% Calculate delays for each microphone
timeDelays = d/c;
delays = round((timeDelays) * Fs);
disp(delays/Fs);

% Create delayed signals for each microphone
delayed_signals = zeros(4, length(signal) + max(delays));
figure;
subplot(5,1,1);
plot(t, signal);
title('Sound source - Original Chirp Signal ');
for i = 1:4
    delayed_signals(i, delays(i) + 1 : delays(i) + length(signal)) = signal;
    subplot(5, 1, i+1);
    plot(t, delayed_signals(i, 1:length(signal)));
    title(['Microphone ', num2str(i)]);
end

% Add white Gaussian noise to the signals
noise_level = 0.00; % Adjust as needed
noisy_signals = delayed_signals + noise_level*randn(size(delayed_signals));

figure;
TOA = zeros(1,4);
for i = 1:4
     % Compute the cross-correlation
    [cross_corr, delay_array] = xcorr(noisy_signals(i, :),signal);

    % Find the maximum peak in the cross-correlation (avoiding negative peaks)
    [max_peak, max_peak_idx] = max(cross_corr);

    % Check if the maximum peak is above a threshold
    if max_peak > 0.05 % Adjust the threshold as needed
        % Calculate the time difference using the index of the maximum peak
        TOA(i) = (delay_array(max_peak_idx) / Fs);
    else
        % Handle the case when no valid peak is found
        TOA(i) = NaN; % or assign some default value
    end
    
    subplot(4, 1, i);
    plot(delay_array / Fs, cross_corr);
    title(['Cross-correlation with Microphone ', num2str(i)]);
    xlabel('Time (s)');
    ylabel('Cross-correlation');
    grid on;
end
disp(TOA);

time_diffs = zeros(1,3);
for i = 2:4
   [cross_corr, lags] = xcorr(noisy_signals(1,:), noisy_signals(i,:));
%[cross_corr, lags] = xcorr(noisy_signals(i,:), noisy_signals(1,:)); % Swap the signals
    [~, idx] = max(cross_corr);
    time_diffs(i-1) = lags(idx) / Fs;
   
end

% Generate a grid of points to evaluate the hyperbolic equation
x_range = 0:0.01:0.8;
y_range = 0:0.01:0.5;
[X, Y] = meshgrid(x_range, y_range);

% Plot the hyperbolas
figure; hold on;
colors = ['r', 'g', 'b'];
for i = 2:4
    Z = c*time_diffs(i-1) + sqrt((X-mic(i,1)).^2 + (Y-mic(i,2)).^2) - sqrt((X-mic(1,1)).^2 + (Y-mic(1,2)).^2);
    contour(X, Y, Z, [0 0], colors(i-1));
end

xlabel('X position (m)');
ylabel('Y position (m)');
title('TDoA Hyperbolas and Source Localization');
grid on; axis equal;

disp(['Actual source position: [', num2str(source_x), ',', num2str(source_y), ']']);
disp(['Estimated source position: [', num2str(estimatedPos(1)), ',', num2str(estimatedPos(2)), ']']);

% ... [Previous code remains unchanged]

% Find intersections
intersections = [];
for i = 1:3
    for j = i+1:4
        % For each pair of mics (i, j)
        Zi = c*time_diffs(i) + sqrt((X-mic(i+1,1)).^2 + (Y-mic(i+1,2)).^2) - sqrt((X-mic(1,1)).^2 + (Y-mic(1,2)).^2);
        Zj = c*time_diffs(j-1) + sqrt((X-mic(j,1)).^2 + (Y-mic(j,2)).^2) - sqrt((X-mic(1,1)).^2 + (Y-mic(1,2)).^2);
        c1 = contourc(x_range, y_range, Zi, [0 0]);
        c2 = contourc(x_range, y_range, Zj, [0 0]);
        intersec = InterX([c1(1,2:end);c1(2,2:end)],[c2(1,2:end);c2(2,2:end)]);
        intersections = [intersections intersec];
    end
end

% Calculate average of intersections as the estimated source position
if ~isempty(intersections)
    estimatedPos = [mean(intersections(1,:)), mean(intersections(2,:))];
else
    estimatedPos = [NaN, NaN];
end

% ... [Display and plotting remains unchanged]


disp(['Estimated source position: [', num2str(estimatedPos(1)), ',', num2str(estimatedPos(2)), ']']);



