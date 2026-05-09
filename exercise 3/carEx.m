I = imread('car_noisy.jpg');
figure;
imagesc(I);
axis image;
title("Noisy image");



% h = ones(2*N+1,2*N+1) / (2*N+1)^2;
% y = filter2(h,I);
% figure
% imshow(y/max(y(:)));

N=5;
y = medfilt2(I,[N N]);
figure
imshow(y);