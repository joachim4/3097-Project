% 
% Define the path to the Python script file
python_script_file = 'PiRecord.py';

% Use the system function to run your Python script
system(['python ', python_script_file]);


sound_source = [0.5 0.1];
sampling_rate = 48000; % Set a sampling rate in Hertz
prop_speed = 343; % Speed of sound value in m/s

SyncSignal =  [0.3 0.3];  
mic_positions = [0, 0;      % Position of mic1
                 0, 0.5;    % Position of mic2
                 0.8, 0;    % Position of mic3
                 0.8, 0.5]; % Position of mic4

Lookup = Create_LTable(100,mic_positions(1,:),mic_positions(2,:),mic_positions(3,:),mic_positions(4,:));     % Generate Look up table for TODA WRT mic 1


[input3, input4] = splitStereoToMono('1pistereo.wav');
[input1, input2] = splitStereoToMono('2pistereo.wav');
[reference_sig,Fs_chirp] = audioread("chirp.wav");

sig1 = SignalFilter(input1);
sig2 = SignalFilter(input2);
sig3 = SignalFilter(input3);
sig4 = SignalFilter(input4);

% SyncSignal ideal distance calculations
sync1 = sqrt((mic_positions(1,1)-SyncSignal(1))^2+(mic_positions(1,2)-SyncSignal(2))^2)/prop_speed; 
sync2 = sqrt((mic_positions(2,1)-SyncSignal(1))^2+(mic_positions(2,2)-SyncSignal(2))^2)/prop_speed;
sync3 = sqrt((mic_positions(3,1)-SyncSignal(1))^2+(mic_positions(3,2)-SyncSignal(2))^2)/prop_speed;
sync4 = sqrt((mic_positions(4,1)-SyncSignal(1))^2+(mic_positions(4,2)-SyncSignal(2))^2)/prop_speed;

toa_cal = zeros(1, 4);
toa_snd = zeros(1, 4);
signals = {sig1, sig2, sig3, sig4};

for i = 1:4
    y = signals{i};

    % First correlation
    [Correlation_arr, lag_arr] = xcorr(y, reference_sig);
    [~, index_of_lag] = max(abs(Correlation_arr));
    peak1 = lag_arr(index_of_lag);

    % Flatten y
    flattern = zeros(1, 3 * sampling_rate);
    flat = length(flattern);
    y(peak1:peak1+flat-1) = flattern;

    % Second correlation
    [Correlation_arr, lag_arr] = xcorr(y, reference_sig);
    [~, index_of_lag] = max(abs(Correlation_arr));
    peak2 = lag_arr(index_of_lag);

    % Calculate TOA
    peaks = [peak1, peak2];
    toa_cal(i) = min(peaks) / sampling_rate;
    toa_snd(i) = max(peaks) / sampling_rate;
end

SyncToa1 = toa_snd(1)-toa_cal(1)+sync1;
SyncToa2 = toa_snd(2)-toa_cal(2)+sync2;
SyncToa3 = toa_snd(3)-toa_cal(3)+sync3;
SyncToa4 = toa_snd(4)-toa_cal(4)+sync4;

Time_diff21 = SyncToa2 - SyncToa1 ;
Time_diff31 = SyncToa3 - SyncToa1 ;
Time_diff41 = SyncToa4 - SyncToa1 ;
Time_diff32 = SyncToa3 - SyncToa2 ;
Time_diff42 = SyncToa4 - SyncToa2 ;
Time_diff43 = SyncToa4 - SyncToa3 ;

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

if (Estimation4(1) ~= 0 && Estimation4(2) ~= 0 && Estimation4(1) ~= mic_positions(4,1) && Estimation4(2) ~= mic_positions(4,2))
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

fprintf("Ideal time of arrival values for the Synchronization sound: \n");
fprintf("Ideal sync ToA at microphone 1: %fs\n",sync1);
fprintf("Ideal sync ToA at microphone 2: %fs\n",sync2);
fprintf("Ideal sync ToA at microphone 3: %fs\n",sync3);
fprintf("Ideal sync ToA at microphone 4: %fs\n",sync4);
fprintf("\n");
fprintf("Detected time of arrival values for the Synchronization sound: \n");
fprintf("Detected sync ToA at microphone 1: %fs\n",toa_cal(1));
fprintf("Detected sync ToA at microphone 2: %fs\n",toa_cal(2));
fprintf("Detected sync ToA at microphone 3: %fs\n",toa_cal(3));
fprintf("Detected sync ToA at microphone 4: %fs\n",toa_cal(4));
fprintf("\n");

fprintf("Detected time of arrival values for the Signal of Interest: \n");
fprintf("Microphone 1: %fs\n",toa_snd(1));
fprintf("Microphone 2: %fs\n",toa_snd(2));
fprintf("Microphone 3: %fs\n",toa_snd(3));
fprintf("Microphone 4: %fs\n",toa_snd(4));
fprintf("\n");


fprintf("Synchronized time of arrival values for the Signal of Interest: \n");
fprintf("Microphone 1: %fs\n",SyncToa1);
fprintf("Microphone 2: %fs\n",SyncToa2);
fprintf("Microphone 3: %fs\n",SyncToa3);
fprintf("Microphone 4: %fs\n",SyncToa4);
fprintf("\n");

fprintf("Time difference of arrival values between microphones: \n");
fprintf("Measured TDoA 21: %fs\n",Time_diff21);
fprintf("Measured TDoA 31: %fs\n",Time_diff31);
fprintf("Measured TDoA 41: %fs\n",Time_diff41);


fprintf("\n");

fprintf("Lookup table estimated position:  X = %.3f  Y = %.3f\n",Triangulation_estimate(1),Triangulation_estimate(2));


% Open the CSV file for appending
fid = fopen('results2.csv', 'a');

% Write the results to the CSV file
fprintf(fid, '%f,%f,%f,%f,%f\n', Triangulation_estimate(1), Triangulation_estimate(2));

% Close the CSV file
fclose(fid);
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


function [monoLeft, monoRight] = splitStereoToMono(stereoWavFile)
% Read the stereo .wav audio file
[stereoWav, ~] = audioread(stereoWavFile);

% Split the stereo signal into its two mono elements and return
monoLeft = stereoWav(:, 1);
monoRight = stereoWav(:, 2);
end

%Function to filter the noisy signals - using the smoothdata function modelling a Gaussian filter
function filteredSig = SignalFilter(noisySig)
filteredSig = smoothdata(noisySig,'sgolay');
end
