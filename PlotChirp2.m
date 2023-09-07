% Calculate the cross-correlation between the chirp and microphone data
chirp_data = hdf5read('chirp.h5', '/I/value') + 1i * hdf5read('chirp.h5', '/Q/value');
mic_data = hdf5read('Mic4.h5','chunk_000001_I') + 1i * hdf5read('Mic4.h5','chunk_000001_Q');

% Extract the real and imaginary parts
chirp_I = real(chirp_data);
chirp_Q = imag(chirp_data);

mic_I = real(mic_data);
mic_Q = imag(mic_data);

N = length(mic_I);
N1 = length(chirp_I)
t = linspace(0,(N-1)/10,N);
t1 = linspace(0,(N-1)/10,N1);

cross_corr_I = xcorr(chirp_I, mic_I);
cross_corr_Q = xcorr(chirp_Q, mic_Q);

% Create a time vector for the cross-correlation
t_cross_corr = linspace(-length(cross_corr_I)/2, length(cross_corr_I)/2, length(cross_corr_I));

% Plot the cross-correlation
figure;
subplot(2, 1, 1);
plot(t_cross_corr, abs(cross_corr_I)); % Plot the absolute value for magnitude
xlabel('Time Lag (s)');
ylabel('Magnitude');
title('Cross-Correlation with Real Part of Mic3');

subplot(2, 1, 2);
plot(t_cross_corr, abs(cross_corr_Q)); % Plot the absolute value for magnitude
xlabel('Time Lag (s)');
ylabel('Magnitude');
title('Cross-Correlation with Imaginary Part of Mic3');

% Plot the real and imaginary parts
figure;
subplot(2, 1, 1);
plot(t, mic_I);
xlabel('Time (s)');
ylabel('I');
title('Real Part of Complex Chirp');

subplot(2, 1, 2);
plot(t, mic_Q);
xlabel('Time (s)');
ylabel('Q');
title('Imaginary Part of Complex Chirp');

figure;
subplot(2, 1, 1);
plot(t1, chirp_I);
xlabel('Time (s)');
ylabel('I');
title('Real Part of Complex Chirp');

subplot(2, 1, 2);
plot(t1, chirp_Q);
xlabel('Time (s)');
ylabel('Q');
title('Imaginary Part of Complex Chirp');
