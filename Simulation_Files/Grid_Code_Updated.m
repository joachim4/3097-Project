%Remove previous data
clear; clc; close all;

sampling_rate = 48000; % Set a sampling rate in Hertz
prop_speed = 343; % Speed of sound value in m/s

% Array storing the positions of our microphones on the grid
mic_positions = [0, 0;      % Position of mic1
                 0, 6.32;    % Position of mic2
                 3.68, 0;    % Position of mic3
                 3.68, 6.32]; % Position of mic4

Lookup = Create_LTable(100,mic_positions(1,:),mic_positions(2,:),mic_positions(3,:),mic_positions(4,:));     % Generate Look up table for TODA WRT mic 1

% Load the chirp signal
[chirpData, chirpSampleRate] = audioread('chirp.wav');
signal = chirpData;

% Specify the file names and store them in a cell array
fileNames = {'wave1.wav', 'wave2.wav', 'wave3.wav', 'wave4.wav'};

% Create a cell array to store the audio data
audioDataArray = cell(1, length(fileNames));

% Create a figure to hold the plots
figure;

% Plot the initial chirp signal
subplot(length(fileNames) + 1, 1, 1);  % Add one more subplot for the chirp
plot((0:length(signal)-1) / chirpSampleRate, signal);
title('Original Chirp Signal');

% Initialize a variable to store the concatenated audio data
maxLength = 0;  % Initialize the maximum length to 0

% Loop through the files, load each one, and store in the cell array
for i = 1:length(fileNames)
    % Load the current .wav file
    [audioData, sampleRate] = audioread(fileNames{i});
    
    % Store the audio data in the cell array
    audioDataArray{i} = audioData;
    
    % Update the maximum length
    maxLength = max(maxLength, length(audioData));
    
    % Create a time vector
    numSamples = length(audioData);
    time = (0:numSamples-1) / sampleRate;
    
    % Plot the waveform with a different color for each file
    subplot(length(fileNames) + 1, 1, i + 1); % Add one more subplot for the chirp
    plot(time, audioData);
    
    % Customize the subplot titles
    title(['Sound Waveform - File ' num2str(i)]);
    
    % Add labels to the last subplot
    if i == length(fileNames)
        xlabel('Time (seconds)');
        ylabel('Amplitude');
    end
end

% Initialize the concatenated audio data matrix with zeros
concatenatedAudioData = zeros(length(fileNames), maxLength);

% Fill in the matrix with the audio data
for i = 1:length(fileNames)
    % Get the audio data for the current file
    audioData = audioDataArray{i};
    
    % Calculate the number of zeros to add for padding
    paddingSize = maxLength - length(audioData);
    
    % Pad the audio data with zeros
    paddedAudioData = [audioData; zeros(paddingSize, 1)];
    
    % Store the padded audio data in the concatenated matrix
    concatenatedAudioData(i, :) = paddedAudioData';
end

% Now, concatenatedAudioData is a 4xN matrix containing all the audio data.


% source_position = [0.8*rand(), 0.5*rand()];


%{ 
Generation of the chirp source signal
   hchirp = dsp.Chirp( ...
    'InitialFrequency', 0,...
    'TargetFrequency', 10, ...
    'TargetTime', 10, ...
    'SweepTime', 100, ...
    'SampleRate', 50, ...
    'SamplesPerFrame', 500);

   chirpData = (step(hchirp))';
%}
%{
[chirpData, ~] = audioread('chirp.wav');
signal = chirpData;

t = (0:1/sampling_rate:(length(signal) - 1) / sampling_rate);

% Specify the file names and store them in a cell array
fileNames = {'kud3.wav', 'kud4.wav', 'kud5.wav', 'kud6.wav'};

% Create a cell array to store the audio data
audioDataArray = cell(1, length(fileNames));

% Create a figure to hold the plots
figure;

% Initialize a variable to store the concatenated audio data
maxLength = 0;  % Initialize the maximum length to 0

% Loop through the files, load each one, and store in the cell array
for i = 1:length(fileNames)
    % Load the current .wav file
    [audioData, sampleRate] = audioread(fileNames{i});
    
    % Store the audio data in the cell array
    audioDataArray{i} = audioData;
    
    % Update the maximum length
    maxLength = max(maxLength, length(audioData));
    
    % Create a time vector
    numSamples = length(audioData);
    time = (0:numSamples-1) / sampleRate;
    
    % Plot the waveform with a different color for each file
    subplot(length(fileNames), 1, i); % Create subplots in a column
    plot(time, audioData);
    
    % Customize the subplot titles
    title(['Sound Waveform - File ' num2str(i)]);
    
    % Add labels to the last subplot
    if i == length(fileNames)
        xlabel('Time (seconds)');
        ylabel('Amplitude');
    end
end

% Initialize the concatenated audio data matrix with zeros
concatenatedAudioData = zeros(length(fileNames), maxLength);

% Fill in the matrix with the audio data
for i = 1:length(fileNames)
    % Get the audio data for the current file
    audioData = audioDataArray{i};
    
    % Calculate the number of zeros to add for padding
    paddingSize = maxLength - length(audioData);
    
    % Pad the audio data with zeros
    paddedAudioData = [audioData; zeros(paddingSize, 1)];
    
    % Store the padded audio data in the concatenated matrix
    concatenatedAudioData(i, :) = paddedAudioData';
end

% Now, concatenatedAudioData is a 4xN matrix containing all the audio data.

%}

%{
% Load the .wav file
[audioData1, ~] = audioread('kud3.wav');
[audioData2, ~] = audioread('kud4.wav');
[audioData3, ~] = audioread('kud5.wav');
[audioData4, ~] = audioread('kud6.wav');

% Create a time vector
numSamples1 = length(audioData1);
time1 = (0:numSamples1-1) / sampling_rate;

numSamples2 = length(audioData2);
time2 = (0:numSamples2-1) / sampling_rate;

numSamples3 = length(audioData3);
time3 = (0:numSamples3-1) / sampling_rate;

numSamples4 = length(audioData4);
time4 = (0:numSamples4-1) / sampling_rate;

% Plot the waveform

plot(time1, audioData1);
plot(time2,audioData2);
plot(time3,audioData3);
plot(time4,audioData4);

%}
% Euclidean distance formula used to calculate the physical distance between 2 points (source to each mic) in meters - stored in array 
%distance_to_mic = sqrt(sum((mic_positions - source_position).^2, 2));


% Calculate delays for each microphone
%perfect_timeDelays = distance_to_mic/prop_speed;
%delays = round((perfect_timeDelays) * sampling_rate);

%sigDelay = zeros(4, length(signal) + max(delays));

% Add noise (Gaussian) to the delayed signals
%[sigNoise, noiseLvl] = AddNoise(sigDelay, 0.4);

% Filter the noisy signals
%filtSignals = SignalFilter(sigNoise);
%{
figure;
subplot(5,1,1);
plot(t, signal);
title('Original Sound source - Chirp Signal');
for i = 1:4
    filtSignals(i, delays(i) + 1 : delays(i) + length(signal)) = signal;
    subplot(5, 1, i+1);
    plot(t, filtSignals(i, 1:length(signal)));
    title(['Received signal at Microphone ', num2str(i)]);
end
%}
%{
figure;
subplot(5,1,1);
plot(time, signal);
title('Original Sound source - Chirp Signal');
for i = 1:4
    concatenatedAudioData(i, delays(i) + 1 : delays(i) + length(signal)) = signal;
    subplot(5, 1, i+1);
    plot(time, concatenatedAudioData(i, 1:length(signal)));
    title(['Received signal at Microphone ', num2str(i)]);
end
%}


figure;
ToA_source2mic = zeros(1,4);
for i = 1:4
     % Cross correlation done on filtered microphone detected signals & original chirp signal
    [cross_corr, delay_array] = xcorr(concatenatedAudioData(i, :),signal);

    % Code to find the maximum peak in the cross-correlation (avoiding negative peaks)
    [max_peak, max_peak_idx] = max(cross_corr);

    % Check if the maximum peak is above a user-defined threshold
    if max_peak > 0.05 % Adjust this threshold value as needed
        % Calculate the time difference using the index of the maximum peak
        ToA_source2mic(i) = (delay_array(max_peak_idx) / sampling_rate);
    else
        % Handle the case when there is no valid peak that's found
        ToA_source2mic(i) = NaN; % or assign some default value
    end
    
    subplot(4, 1, i);
    plot(delay_array / sampling_rate, cross_corr);
    title(['Cross-correlation with Microphone ', num2str(i)]);
    xlabel('Time (s)');
    ylabel('Cross-correlation');
    grid on;
end

Time_diff21 = ToA_source2mic(2) - ToA_source2mic(1);
Time_diff31 = ToA_source2mic(3) - ToA_source2mic(1);
Time_diff41 = ToA_source2mic(4) - ToA_source2mic(1);
Time_diff32 = ToA_source2mic(3) - ToA_source2mic(2);
Time_diff42 = ToA_source2mic(4) - ToA_source2mic(2);
Time_diff43 = ToA_source2mic(4) - ToA_source2mic(3);


[Estimation1, Estimation2, Estimation3, Estimation4]   = find_position(Lookup,Time_diff21,Time_diff31,Time_diff41,Time_diff32,Time_diff42,Time_diff43);


estimations = [];

% Compare position estimations
if (Estimation1(1) ~= 0 && Estimation1(2) ~= 0 && Estimation1(1) ~= mic_positions(4,1) && Estimation1(2) ~= mic_positions(4,2))
    estimations(:, end+1) = Estimation1;
end

if (Estimation2(1) ~= mic_positions(1,1) && Estimation2(2) ~= mic_positions(1,1) && Estimation2(1) ~= mic_positions(4,1) && Estimation2(2) ~= mic_positions(4,2))
    estimations(:, end+1) = Estimation2';
end

if (Estimation3(1) ~= 0 && Estimation3(2) ~= 0 && Estimation3(1) ~= mic_positions(4,1) && Estimation3(2) ~= mic_positions(4,2))
    estimations(:, end+1) = Estimation3';
end

if (Estimation4(1) ~= 0 && Estimation4(2) ~= 0 && Estimation4(1) ~= mic_positions(4,1) && Estimation4(2) ~= mic_positions(4,2));
    estimations(:, end+1) = Estimation4';
end

estimations( :, all(~estimations,1) ) = [];
if isempty(estimations)
    disp("Estimation error - inaccurate triangulated position")
    Triangulation_estimate = Estimation1;
else
    Triangulation_estimate(1) = mean(estimations(1,:));   
    Triangulation_estimate(2) = mean(estimations(2,:));

end

%fprintf("Actual Source position:  X = %.3f  Y = %.3f\n",source_position(1),source_position(2));
fprintf("Lookup table estimated position:  X = %.3f  Y = %.3f\n",Triangulation_estimate(1),Triangulation_estimate(2));

function [LTable] = Create_LTable(table_resolution,mic1, mic2, mic3, mic4)

    Incrementor = 1;

  % Setting the x and y table limits based on the microphone positions
    x_min = min([mic1(1), mic2(1), mic3(1), mic4(1)]);
    x_max = max([mic1(1), mic2(1), mic3(1), mic4(1)]);
    y_min = min([mic1(2), mic2(2), mic3(2), mic4(2)]);
    y_max = max([mic1(2), mic2(2), mic3(2), mic4(2)]);
    
    % Calculation of the number of points for the table - based on the user defined table resolution
    num_points_x = round((x_max - x_min) * table_resolution);
    num_points_y = round((y_max - y_min) * table_resolution);
    num_points = num_points_x * num_points_y;
    
    % Initialize the lookup table
    LTable = zeros(num_points, 8);
    
    for i = 1:num_points_x
        for j = 1:num_points_y
            % Calculate the x and y values for this point
            x = x_min + (i - 1) / table_resolution;
            y = y_min + (j - 1) / table_resolution;
            
            % Calculate the time differences for each microphone
            TOA1 = sqrt((mic1(1) - x)^2 + (mic1(2) - y)^2) / 343;
            TOA2= sqrt((mic2(1) - x)^2 + (mic2(2) - y)^2) / 343;
            TOA3 = sqrt((mic3(1) - x)^2 + (mic3(2) - y)^2) / 343;
            TOA4 = sqrt((mic4(1) - x)^2 + (mic4(2) - y)^2) / 343;
            
            % Calculate the time differences between microphones
            TDoA21 = TOA2 - TOA1;
            TDoA31 = TOA3 - TOA1;
            TDoA41 = TOA4 - TOA1;
            TDoA32 = TOA3 - TOA2;
            TDoA42 = TOA4 - TOA2;
            TDoA43 = TOA4 - TOA3;
            
            % Store the values in the lookup table
            LTable(Incrementor, 1) = TDoA21;
            LTable(Incrementor, 2) = TDoA31;
            LTable(Incrementor, 3) = TDoA41;
            LTable(Incrementor, 4) = TDoA32;
            LTable(Incrementor, 5) = TDoA42;
            LTable(Incrementor, 6) = TDoA43;
            LTable(Incrementor, 7) = x;
            LTable(Incrementor, 8) = y;
            
            % Increment the counter
            Incrementor = Incrementor + 1;
        end
    end
end


function [Estimation1, Estimation2, Estimation3, Estimation4] = find_position(LTable,t21, t31, t41, t32, t42, t43)

    td1 = LTable(:, 4:6);
    td2 = [LTable(:, 2), LTable(:, 3), LTable(:, 6)];
    td3 = [LTable(:, 1), LTable(:, 3), LTable(:, 5)];
    td4 = [LTable(:, 1), LTable(:, 2), LTable(:, 4)];

    % Created variables for the individual time differences
    td_N1_1 = t32;
    td_N1_2 = t42;
    td_N1_3 = t43;

    td_N2_1 = t31;
    td_N2_2 = t41;
    td_N2_3 = t43;

    td_N3_1 = t21;
    td_N3_2 = t41;
    td_N3_3 = t42;

    td_N4_1 = t21;
    td_N4_2 = t31;
    td_N4_3 = t32;


% Calculated the time differences using bsxfun function
diff1 = bsxfun(@minus, [td1(:, 1), td1(:, 2), td1(:, 3)], [td_N1_1, td_N1_2, td_N1_3]);
diff2 = bsxfun(@minus, [td2(:, 1), td2(:, 2), td2(:, 3)], [td_N2_1, td_N2_2, td_N2_3]);
diff3 = bsxfun(@minus, [td3(:, 1), td3(:, 2), td3(:, 3)], [td_N3_1, td_N3_2, td_N3_3]);
diff4 = bsxfun(@minus, [td4(:, 1), td4(:, 2), td4(:, 3)], [td_N4_1, td_N4_2, td_N4_3]);


    [~, IN1] = min(sum(abs(diff1) .* 2, 2));
    [~, IN2] = min(sum(abs(diff2) .* 2, 2));
    [~, IN3] = min(sum(abs(diff3) .* 2, 2));
    [~, IN4] = min(sum(abs(diff4) .* 2, 2));

  
Estimation1 = LTable(IN1, [7, 8]);
Estimation2 = LTable(IN2, [7, 8]);
Estimation3 = LTable(IN3, [7, 8]);
Estimation4 = LTable(IN4, [7, 8]);

end

%Function to add Gaussian white noise to the microphone-received signals(according to a user-defined level of noise)
function [noisySig, noiseLvl] = AddNoise(delayedSig, level)
noiseLvl = level*randn(size(delayedSig));
%disp(noiseLvl);
noisySig = delayedSig + noiseLvl;
end

%Function to filter the noisy signals - using the smoothdata function modelling a Gaussian filter
function filteredSig = SignalFilter(noisySig)
%filteredSig = noisySig + 0.0*randn(size(noisySig));
filteredSig = smoothdata(noisySig,'gaussian');
end

