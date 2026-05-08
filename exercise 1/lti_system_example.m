% Example coefficients
b = [0.5, 1.2, -0.7];
a = [1, -0.3, 0.6, -0.1];

% Frequency response of system
[H, w] = freqz(b, a, 1000);

figure;
subplot(2, 1, 1);
plot(w/pi, 20*log10(abs(H)));
title('Magnitude of Frequency Responsesystem');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
subplot(2, 1, 2);
plot(w/pi, angle(H));
title('Phase of Frequency Response for system');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase');

% Signal generation
n = 0:999;
x = 2*cos(0.2*pi*n) - 3*sin(0.45*pi*n) + (1/2) .^ n;
y = filter(b, a, x);

% System implemented with filter() function
figure;
subplot(2, 1, 1);
hold on;
plot(x(1:100));
plot(y(1:100));
hold off;
title('First 100 samples of output');
xlabel('Samples');
ylabel('System Output');
legend ('Input x', 'filter()');
subplot(2, 1, 2);
hold on;
plot(x);
plot(y);
hold off;
title('Last 100 samples of output');
xlabel('Samples');
ylabel('System Output');
legend ('Input x', 'filter()');
xlim([900, 1000]);
xticks(900:10:1000);
sgtitle('System using filter() function');



% Compute FFT of input and output signals
NFFT = 1024;
X = fftshift(fft(x, NFFT));
Y = fftshift(fft(y, NFFT));

% Normalized frequency axis from -1 to 1
f = linspace(-1, 1, NFFT);

% Magnitude plots
figure;
subplot(2, 1, 1);
plot(f, 20*log10(abs(X)));
title('Magnitude Spectrum of Input Signal');
xlabel('Normalized Frequency');
ylabel('Magnitude (dB)');
grid on;
subplot(2, 1, 2);
plot(f, 20*log10(abs(Y)));
title('Magnitude Spectrum of Output Signal');
xlabel('Normalized Frequency');
ylabel('Magnitude (dB)');
grid on;

% Phase plots
figure;
subplot(2, 1, 1);
plot(f, unwrap(angle(X)));
title('Phase Spectrum of Input Signal');
xlabel('Normalized Frequency');
ylabel('Phase (radians)');
grid on;
subplot(2, 1, 2);
plot(f, unwrap(angle(Y)));
title('Phase Spectrum of Output Signal');
xlabel('Normalized Frequency');
ylabel('Phase (radians)');
grid on;