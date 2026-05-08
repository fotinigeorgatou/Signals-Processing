[b1,a1] = cheby1(10, 10, 0.1);
[b2,a2]=cheby2(10,20,0.1);
[b3,a3]=butter(10, 0.1);

% Frequency response of IIR system
[H1, w1] = freqz(b1, a1, 1000);
[H2, w2] = freqz(b2, a2, 1000);
[H3, w3] = freqz(b3, a3, 1000);


NumFFT=4096;
Y=abs(fftshift(fft(y,NumFFT)));
Y_n=abs(fftshift(fft(y_n,NumFFT)));

y1_filtered= filtfilt(h1,1,y_n);
figure;
plot(y1_filtered);

[h, n] = impz(b1, a1, 50);

figure;
stem(h1);
title('Impulse Response for IIR filter');
xlabel('Sample');
ylabel('Coefficient Value');
grid on;

sound(y1_filtered);

y2_filtered = filtfilt(h2, 1, y_n);
sound(y2_filtered);
figure;
plot(y2_filtered);

[h, n] = impz(b2, a2, 50);

figure;
stem(h2);
title('Impulse Response for IIR filter');
xlabel('Sample');
ylabel('Coefficient Value');
grid on;


y3_filtered = filtfilt(h3,1,y_n);
sound(y3_filtered);

figure;
plot(y3_filtered);

[h, n] = impz(b3, a3, 50);

figure;
stem(h3);
title('Impulse Response for IIR filter');
xlabel('Sample');
ylabel('Coefficient Value');
grid on;



e1= y1_filtered - y;
e2 = y2_filtered - y;
e3 = y3_filtered - y;

MSE=[mean(e1.^2) mean(e2.^2) mean(e3.^2)];



% % Chebyshev Type I
% figure
% zplane(b1, a1);
% title('Chebyshev Type I - Poles/Zeros');
% grid on;
% 
% % Chebyshev Type I
% figure
% zplane(b2, a2);
% title('Chebyshev Type II - Poles/Zeros');
% grid on;
% 
% % Chebyshev Type I
% figure
% zplane(b3, a3);
% title('Butterworth - Poles/Zeros');
% grid on;


% 
% figure;
% plot(w1/pi, 20*log10(abs(H1)));
% hold on;
% plot(w2/pi, 20*log10(abs(H2)));
% plot(w3/pi, 20*log10(abs(H3)));
% legend('cheby1','cheby2','butterworth');
% title('Magnitude of Frequency Response for IIR filter');
% xlabel('Normalized Frequency (\times\pi rad/sample)');
% ylabel('Magnitude (dB)');
% grid on;
% figure;
% plot(w1/pi, angle(H1));
% hold on;
% plot(w2/pi, angle(H2));
% plot(w3/pi, angle(H3));
% legend('cheby1','cheby2','butterworth');
% title('Phase of Frequency Response for IIR filter');
% xlabel('Normalized Frequency (\times\pi rad/sample)');
% ylabel('Phase');
% grid on;