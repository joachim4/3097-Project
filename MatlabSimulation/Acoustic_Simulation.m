c = 343; % Speed of sound in m/s
f = 440; % Frequency of source in Hz
Fs = 44100; % Sampling rate in Hz
duration = 0.1; % Duration of the signal in seconds

mic1 = [0,0];
mic2 = [0.8,0];
mic3 = [0.,0.5];
mic4 = [0.8,0.5];

x_soundsource = rand()*0.8;
y_soundsource = rand()*0.5;

soundsource = [x_soundsource,y_soundsource];

dist1 = sqrt(sum((mic1-soundsource).^2, 2));
dist2 = sqrt(sum((mic2-soundsource).^2, 2));
dist3 = sqrt(sum((mic3-soundsource).^2, 2));
dist4 = sqrt(sum((mic4-soundsource).^2, 2));

timeDelay1 = (dist1)/c;
timeDelay2 = (dist2)/c;
timeDelay3 = (dist3)/c;
timeDelay4 = (dist4)/c;

delaySig1 = zeros()

