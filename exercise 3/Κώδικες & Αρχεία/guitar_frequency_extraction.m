video = VideoReader('500fps.avi');

i = 0;
x = 293;
y = 323;
FPS = 500;
while hasFrame(video)
    i = i + 1;
    I_clean = rgb2gray(im2double(readFrame(video)));
    sample(i) = I_clean(x, y);
end

signal = sample - mean(sample);

FFT = abs(fftshift(fft(signal, 1024)));
F = linspace(-FPS/2, FPS/2, 1024);

figure;
plot(F, FFT);
title("String's Spectral Contents");