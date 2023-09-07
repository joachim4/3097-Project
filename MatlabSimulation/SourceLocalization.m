L = 300;

N = 4;
rxULA = phased.ULA('Element',phased.OmnidirectionalMicrophoneElement,...
    'NumElements',N);

rxpos1 = [0;0;0];
rxvel1 = [0;0;0];
rxax1 = azelaxes(90,0);

rxpos2 = [L;0;0];
rxvel2 = [0;0;0];
rxax2 = rxax1;

% Add two more receiver positions, velocities, and axes
rxpos3 = [0;L;0];
rxvel3 = [0;0;0];
rxax3 = azelaxes(90,0);

rxpos4 = [L;L;0];
rxvel4 = [0;0;0];
rxax4 = rxax3;

srcpos = [L/2;L/2;0];
srcvel = [0;0;0];
srcax = azelaxes(-90,0);
srcULA = phased.OmnidirectionalMicrophoneElement;

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

plot(chirpData);

fc = 15000;             % 300 kHz
c = 343;               % 1500 m/s
dmax = 343;             % 150 m
pri = (2*dmax)/c;
prf = 1/pri;
bw = 6000;           % 100 kHz
fs = 2*bw;
chirp_slope = bw / pri;  % Calculate chirp slope (rate of change of frequency)

waveform = phased.LinearFMWaveform('SampleRate',fs,'SweepBandwidth',bw,...
   'PRF',prf,'PulseWidth',pri/10);




%waveform = phased.LinearFMWaveform(chirpData);
%%waveform = phased.CustomFMWaveform()
%%waveform =  phased.RectangularWaveform("SampleRate",fs);a
signal = waveform();
plot(abs(waveform()));
title('Received Signal at Receiver 1');
xlabel('Sample Index');
ylabel('Amplitude');
nfft = 128;

radiator = phased.WidebandRadiator('Sensor',srcULA,...
    'PropagationSpeed',c,'SampleRate',fs,...
    'CarrierFrequency',fc,'NumSubbands',nfft);

% Create collectors for all 4 receiver arrays
collector1 = phased.WidebandCollector('Sensor',rxULA,...
    'PropagationSpeed',c,'SampleRate',fs,...
    'CarrierFrequency',fc,'NumSubbands',nfft);
collector2 = phased.WidebandCollector('Sensor',rxULA,...
    'PropagationSpeed',c,'SampleRate',fs,...
    'CarrierFrequency',fc,'NumSubbands',nfft);
collector3 = phased.WidebandCollector('Sensor',rxULA,...
    'PropagationSpeed',c,'SampleRate',fs,...
    'CarrierFrequency',fc,'NumSubbands',nfft);
collector4 = phased.WidebandCollector('Sensor',rxULA,...
    'PropagationSpeed',c,'SampleRate',fs,...
    'CarrierFrequency',fc,'NumSubbands',nfft);

channel1 = phased.WidebandFreeSpace('PropagationSpeed',c,...
    'SampleRate',fs,'OperatingFrequency',fc,'NumSubbands',nfft);
channel2 = phased.WidebandFreeSpace('PropagationSpeed',c,...
    'SampleRate',fs,'OperatingFrequency',fc,'NumSubbands',nfft);
channel3 = phased.WidebandFreeSpace('PropagationSpeed',c,...
    'SampleRate',fs,'OperatingFrequency',fc,'NumSubbands',nfft);
channel4 = phased.WidebandFreeSpace('PropagationSpeed',c,...
    'SampleRate',fs,'OperatingFrequency',fc,'NumSubbands',nfft);

[~,ang1t] = rangeangle(rxpos1,srcpos,srcax);
[~,ang2t] = rangeangle(rxpos2,srcpos,srcax);
[~,ang3t] = rangeangle(rxpos3,srcpos,srcax);
[~,ang4t] = rangeangle(rxpos4,srcpos,srcax);

sigt = radiator(signal,[ang1t ang2t ang3t ang4t]);

% Update signal propagation through channels for all 4 receivers
sigp1 = channel1(sigt(:,1),srcpos,rxpos1,srcvel,rxvel1);
sigp2 = channel2(sigt(:,2),srcpos,rxpos2,srcvel,rxvel2);
sigp3 = channel3(sigt(:,3),srcpos,rxpos3,srcvel,rxvel3);
sigp4 = channel4(sigt(:,4),srcpos,rxpos4,srcvel,rxvel4);

[~,ang1r] = rangeangle(srcpos,rxpos1,rxax1);
[~,ang2r] = rangeangle(srcpos,rxpos2,rxax2);
[~,ang3r] = rangeangle(srcpos,rxpos3,rxax3);
[~,ang4r] = rangeangle(srcpos,rxpos4,rxax4);

% Update collector inputs for all 4 receivers
sigr1 = collector1(sigp1,ang1r);
sigr2 = collector2(sigp2,ang2r);
sigr3 = collector3(sigp3,ang3r);
sigr4 = collector4(sigp4,ang4r);

% ... (previous code) ...

% Extract the received signals at each receiver
received_signal1 = sigr1;
received_signal2 = sigr2;
received_signal3 = sigr3;
received_signal4 = sigr4;

% Find the index of the maximum correlation value (lag)
[~, lagIndex] = max(crossCorrelation);
lag = lagIndex - (length(signal1) - 1); % Compute lag in samples

fprintf('The maximum cross-correlation occurs at lag: %d samples\n', lag);

subplot(4, 1, 1);
plot(abs(received_signal1));
title('Received Signal at Receiver 1');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(4, 1, 2);
plot(abs(received_signal2));
title('Received Signal at Receiver 2');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(4, 1, 3);
plot(abs(received_signal3));
title('Received Signal at Receiver 3');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(4, 1, 4);
plot(abs(received_signal4));
title('Received Signal at Receiver 4');
xlabel('Sample Index');
ylabel('Amplitude');

% Optional: Adjust the plot layout for better visualization
sgtitle('Received Signals at Receivers');


% Create GCCEstimators for all 4 receivers
doa1 = phased.GCCEstimator('SensorArray',rxULA,'SampleRate',fs,...
    'PropagationSpeed',c);
doa2 = phased.GCCEstimator('SensorArray',rxULA,'SampleRate',fs,...
    'PropagationSpeed',c);
doa3 = phased.GCCEstimator('SensorArray',rxULA,'SampleRate',fs,...
    'PropagationSpeed',c);
doa4 = phased.GCCEstimator('SensorArray',rxULA,'SampleRate',fs,...
    'PropagationSpeed',c);

% Estimate DOA for all 4 receivers
angest1 = doa1(sigr1);
angest2 = doa2(sigr2);
angest3 = doa3(sigr3);
angest4 = doa4(sigr4);

fprintf("DoA mic1: %fs\n",angest1);
fprintf("DoA mic2: %fs\n",angest2);
fprintf("DoA mic3: %fs\n",angest3);
fprintf("DoA mic4: %fs\n",angest4);

% Calculate source position estimates for the first pair of receivers
yest1 = L/(abs(tand(angest1)) + abs(tand(angest2)));
xest1 = yest1*abs(tand(angest1));
zest1 = 0;
srcpos_est1 = [xest1;yest1;zest1];

% Calculate source position estimates for the second pair of receivers
yest2 = L/(abs(tand(angest3)) + abs(tand(angest4)));
xest2 = yest2*abs(tand(angest3));
zest2 = 0;
srcpos_est2 = [xest2;yest2;zest2];

% Display source position estimates for both pairs of receivers
disp(srcpos_est1);
disp(srcpos_est2);
