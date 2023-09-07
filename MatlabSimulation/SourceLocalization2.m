L = 100;  % Half of the grid size

N = 4;
rxULA = phased.ULA('Element',phased.OmnidirectionalMicrophoneElement,...
    'NumElements',N);

% Receiver positions
rxpos1 = [0; 0; 0];
rxpos2 = [0; L; 0];
rxpos3 = [L; 0; 0];
rxpos4 = [L; L; 0];

% Sound source positioned in the middle of the grid
srcpos = [L/2; L/2; 0];
srcvel = [0; 0; 0];
srcax = azelaxes(-90, 0);
srcULA = phased.OmnidirectionalMicrophoneElement;

% Rest of the code remains the same as before
fc = 300e3;             % 300 kHz
c = 1500;               % 1500 m/s
dmax = 150;             % 150 m
pri = (2*dmax)/c;
prf = 1/pri;
bw = 100.0e3;           % 100 kHz
fs = 2*bw;
waveform = phased.LinearFMWaveform('SampleRate',fs,'SweepBandwidth',bw,...
    'PRF',prf,'PulseWidth',pri/10);

signal = waveform();

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

% Calculate the angles of arrival for all receivers
[~,ang1t] = rangeangle(rxpos1, srcpos, srcax);
[~,ang2t] = rangeangle(rxpos2, srcpos, srcax);
[~,ang3t] = rangeangle(rxpos3, srcpos, srcax);
[~,ang4t] = rangeangle(rxpos4, srcpos, srcax);

sigt = radiator(signal, [ang1t, ang2t, ang3t, ang4t]);

% Update signal propagation through channels for all 4 receivers
sigp1 = channel1(sigt(:, 1), srcpos, rxpos1, srcvel, rxvel1);
sigp2 = channel2(sigt(:, 2), srcpos, rxpos2, srcvel, rxvel2);
sigp3 = channel3(sigt(:, 3), srcpos, rxpos3, srcvel, rxvel3);
sigp4 = channel4(sigt(:, 4), srcpos, rxpos4, srcvel, rxvel4);

% Calculate the angles of arrival at the receivers
[~,ang1r] = rangeangle(srcpos, rxpos1, rxax1);
[~,ang2r] = rangeangle(srcpos, rxpos2, rxax2);
[~,ang3r] = rangeangle(srcpos, rxpos3, rxax3);
[~,ang4r] = rangeangle(srcpos, rxpos4, rxax4);

% Update collector inputs for all 4 receivers
sigr1 = collector1(sigp1, ang1r);
sigr2 = collector2(sigp2, ang2r);
sigr3 = collector3(sigp3, ang3r);
sigr4 = collector4(sigp4, ang4r);

% Create GCCEstimators for all 4 receivers
doa1 = phased.GCCEstimator('SensorArray', rxULA, 'SampleRate', fs,...
    'PropagationSpeed', c);
doa2 = phased.GCCEstimator('SensorArray', rxULA, 'SampleRate', fs,...
    'PropagationSpeed', c);
doa3 = phased.GCCEstimator('SensorArray', rxULA, 'SampleRate', fs,...
    'PropagationSpeed', c);
doa4 = phased.GCCEstimator('SensorArray', rxULA, 'SampleRate', fs,...
    'PropagationSpeed', c);

% Estimate DOA for all 4 receivers
angest1 = doa1(sigr1);
angest2 = doa2(sigr2);
angest3 = doa3(sigr3);
angest4 = doa4(sigr4);

% Calculate source position estimates for the first pair of receivers
yest1 = L/(abs(tand(angest1)) + abs(tand(angest2)));
xest1 = yest1*abs(tand(angest1));
zest1 = 0;
srcpos_est1 = [xest1; yest1; zest1];

% Calculate source position estimates for the second pair of receivers
yest2 = L/(abs(tand(angest3)) + abs(tand(angest4)));
xest2 = yest2*abs(tand(angest3));
zest2 = 0;
srcpos_est2 = [xest2; yest2; zest2];

% Display source position estimates for both pairs of receivers
disp(srcpos_est1);
disp(srcpos_est2);
