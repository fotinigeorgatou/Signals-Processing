load chirp
y0=y;

noise =0.5*randn(size(y));
Fs = 8919;

yw = y0 + noise;



figure
subplot(131);plot(y0)
subplot(132);plot(yw)

NumFFT = 4096;
F = linspace(-Fs/2,Fs/2,NumFFT);



b = fir1(34,0.48,'high',chebwin(35,30));


yf = filter(b,1,yw);
subplot(133);plot(yf)

freqz(b,1,512);


figure
subplot(131);plot(F, abs(fftshift(fft(y0,NumFFT))))
subplot(132);plot(F, abs(fftshift(fft(yw,NumFFT))))
subplot(133);plot(F, abs(fftshift(fft(yf,NumFFT))))

sound(y, Fs)
sound(yw, Fs)
sound(yf, Fs)
