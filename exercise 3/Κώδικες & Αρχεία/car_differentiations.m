h = [1, -1];
I = imread('car.jpg');

figure;
imagesc(I);
axis image;
colormap gray;
title("Original image");

% Differentiation upon vertical y axis
f_y = filter(h, 1, I, [], 1);
figure;
imagesc(f_y);
axis image;
colormap gray;
title("∂I(x, y) / ∂y");

% Differentiation upon horizontal x axis
f_x = filter(h, 1, I, [], 2);
figure;
imagesc(f_x);
axis image;
colormap gray;
title("∂I(x, y) / ∂x");

% Differentiation upon vertical y axis
f_y2 = filter(h, 1, f_y, [], 1);
figure;
imagesc(f_y2);
axis image;
colormap gray;
title("∂^2I(x, y) / ∂y^2");


% Differentiation upon horizontal x axis
f_x2 = filter(h, 1, f_x, [], 2);
figure;
imagesc(f_x2);
axis image;
colormap gray;
title("∂^2I(x, y) / ∂x^2");




f_xy=filter(h,1,f_x,[],1);
figure;
imagesc(f_xy);
axis image;
colormap gray;
title("∂^2I(x, y) / ∂x∂y");


Laplacian=f_x2+f_y2;
figure;
imagesc(Laplacian);
axis image;
colormap gray;
title("Laplacian");

%Gradient Magnitude
Gradient=sqrt(f_x.^2+f_y.^2);
figure;
imagesc(Gradient);
axis image;
colormap gray;
title("Gradient Magnitude");