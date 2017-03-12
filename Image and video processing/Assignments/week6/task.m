% Test tasks for the Week 6
clear all; close all; clc;


% Active contours using the level sets method

% Image downloaded as PNG from
% https://commons.wikimedia.org/wiki/File:Flag_of_Switzerland_%28Pantone%29.svg
img = 255 - rgb2gray(imread('../320px-Flag_of_Switzerland_(Pantone).svg.png'));


% Prepare initial Phi at t=0.
% Inside a circle, centered in the middle of the image and with the
% diameter of 90% of the image's shorter side, Phi will be positive,
% outside this circle it will be negative
[m, n] = size(img);
xc = m / 2;
yc = n / 2;
r = 0.9 * min(m, n) / 2;
xv = ((1 : m) - xc).^2;
yv = ((1 : n) - yc).^2;
phi0 = zeros(m, n);
for x = 1 : m
    for y = 1 : n
        % Phi = 1 - (d(p, c)/r)^2
        phi0(x, y) = 1 - (xv(x) + yv(y))/(r*r);
    end  % for y
end  % for x

disp('Figure 1: The original image and the initial curve');
figure(1);
imshow(img);
hold on;
contour(phi0>0);
hold off;

sgt = img_active_contour(img, phi0, 0.2, 5000);
disp('Figure 2: The original image and the detected edge contour');
figure(2);
imshow(img);
hold on;
contour(sgt);
hold off;
