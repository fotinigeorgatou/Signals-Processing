NumFFT = 4096;
Y=abs(fftshift(fft(y,NumFFT)));
Y_n=abs(fftshift(fft(y_n,NumFFT)));

%sound(y);

h1=fir1(34,0.48,chebwin(35,35),'high');
h2= firls(34,[0, 0.45, 0.5, 1], [0,1,1,0]);
h3=firpm(34,[0, 0.45, 0.5, 1], [0,1,1,0]);

[H1, w1] = freqz(h1, 1, 1000);
[H2, w2] = freqz(h2, 1, 1000);
[H3, w3] = freqz(h3, 1, 1000);

y1_filtered= filtfilt(h1,1,y_n);
sound(y1_filtered);

y2_filtered = filtfilt(h2, 1, y_n);
sound(y2_filtered);

y3_filtered = filtfilt(h3,1,y_n);
sound(y3_filtered);

e1= y1_filtered - y;
e2 = y2_filtered - y;
e3 = y3_filtered - y;

MSE=[mean(e1.^2) mean(e2.^2) mean(e3.^2)];

figure;
plot(y3_filtered);


figure;
plot(w3/pi, 20*log10(abs(H3)));
title('Magnitude of Frequency Response for FIR filter');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
grid on;

