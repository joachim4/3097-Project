% Load the complex chirp from the HDF5 file
chirp_data = hdf5read('chirp.h5', '/I/value') + 1i * hdf5read('chirp.h5', '/Q/value');
mic_data = hdf5read('Mic2.h5','chunk_000001_I') + 1i * hdf5read('Mic2.h5','chunk_000001_Q');



% Extract the real and imaginary parts
I = real(chirp_data);
Q = imag(chirp_data);

N = length(I);
t = linspace(0,(N-1)/10,N);

% Create a time vector
%t = linspace(0, Tm, numel(I));
[Correlation_Array , Delay_Array] = xcorr(mic_data, chirp_data);
[~, TOA_Index] = max(Correlation_Array);
TOA = Delay_Array(TOA_Index);
disp(TOA);
% Plot the real and imaginary parts
figure;
subplot(2, 1, 1);
plot(t, I);
xlabel('Time (s)');
ylabel('I');
title('Real Part of Complex Chirp');

subplot(2, 1, 2);
plot(t, Q);
xlabel('Time (s)');
ylabel('Q');
title('Imaginary Part of Complex Chirp');
