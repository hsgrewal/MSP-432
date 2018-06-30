N = 2^11 + 1000;   % Signal length (not order of 2)

% Sinusoidal 1 params
a1 = 1;
f1 = 100;

% Sinusoidal 2 params
a2 = 2.5;
f2 = 300;

% Sum Sinusoidal
fs = 1e3;
t = 0:1/fs:(N-1)/fs;
x = a1.*cos(2*pi*f1*t) + a2.*sin(2*pi*f2*t);

% FFT
nfft = 2.^nextpow2(N);	% Next power of 2
X = fft(x,nfft);

% Magnitude
fft_len = length(X);
f_fft = linspace(0,fs/2,fft_len/2);
mag_fft = abs(X(1:fft_len/2));

% Plot Magnitude
figure();
plot(f_fft,mag_fft);
hold on;
title('FFT');
ylabel('Mag');
xlabel('Frequency (Hz)');
