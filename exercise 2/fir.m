
%h=firls(28,[0,0.1,0.35,1],[0,1,1, 0]);

h=firpm(28,[0,0.1,0.35,1], [0,1,1,0]);

% Frequency response of FIR system
[H, w] = freqz(h, 1, 1000);

figure;
plot(w/pi, 20*log10(abs(H)));
title('Magnitude of Frequency Response for FIR filter');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
grid on;

figure;
plot(w/pi, angle(H));
title('Phase of Frequency Response for FIR filter');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase');
grid on;

figure;
stem(h);
title('Impulse Response for FIR filter');
xlabel('Sample');
ylabel('Coefficient Value');
grid on;
