% Test tasks for the Week 5
clear all; close all; clc;

% The test image of coins can be downloaded from:
% https://commons.wikimedia.org/wiki/File:Coin_Christian_the_Elder_of_Brunswick_and_Luneburg.png

% Load the image and threshold it:
img = edge(imread('../Coin_Christian_the_Elder_of_Brunswick_and_Luneburg.png'), 'sobel');

% Display the image:
disp('Figure 1: the original image')
figure(1);
imshow(img);

[ Hc, pc, qc, rc]= img_hough_circle(img);
nimg = img_draw_circles(img, Hc, pc, qc, rc, 5);

figure(2);
disp('Figure 2: the original image with detected circles in gray');
imshow(nimg);

rep = input('Press any key to continue...', 's');
close all;  clear all;


% Test of Hough transform to detect ellipses

% Image downladed (as .png) from:
% https://commons.wikimedia.org/wiki/File:Ru_ball.svg
img =  imresize(edge(rgb2gray(imread('../200px-Ru_ball.svg.png')), 'sobel'), 0.5);

disp('Figure 1: the original image with detected edges');
figure(1);
imshow(img);

[pe, qe, ae, be, thetae] = img_hough_ellipse(img, 20, 35);
nimg = img_draw_ellipses(img, pe, qe, ae, be, thetae);
disp('Figure 2: the original image with detectedellipses in gray');
figure(2);
imshow(nimg);


rep = input('Press any key to continue...', 's');
close all;  clear all;


% Test of Otsu's algorithm

% Image with 3 colors downloaded (as .png) from:
% https://commons.wikimedia.org/wiki/File:Wallpaper_group_diagram_legend_rotation4.svg
img = rgb2gray(imread('../500px-Wallpaper_group_diagram_legend_rotation4.svg.png'));

disp('Figure 1: the original 3 colored image');
figure(1);
imshow(img);

h = imhist(img);

disp('Figure 2: histogram of the original image');
figure(2);
bar(h);

% Add Gaussian noise to the image:
nimg = imnoise(img, 'gaussian', 0, 0.2);
 
disp('Figure 3: image with added Gaussian noise');
figure(3);
imshow(nimg);
 
th = img_otsu(nimg);
fprintf('Detected threshold: %f\n', th);

disp('Figure 4: histogram of the noisy image with the detected threshold');
h = imhist(nimg);
h1 = zeros(1, numel(h));
h1(th-1) = max(h) + 500;
figure(4);
bar(h1, 'Facecolor', 'red', 'BarWidth', 0.1);
hold on
bar(h, 'Facecolor', 'blue', 'BarWidth', 1);
hold off

disp('Figure 5: binary image with the threshold applied');
figure(5);
imshow( nimg>th );


rep = input('Press any key to continue...', 's');
close all;  clear all;


% Segmentation by region growing:

% Test image downloaded from:
% https://en.wikipedia.org/wiki/File:Regiongrowing_figure_Original.jpg
img = imread('../Regiongrowing_figure_Original.jpg');

disp('Figure 1: the original image');
figure(1);
imshow(img);

seeds=[78, 75, 55, 127, 143, 131, 132, 264; 230, 242, 205, 267, 267, 324, 332, 265 ];
bwimg = img_region_grow(img, seeds);
disp('Figure 2: image, segmented using the image growing method');
figure(2);
imshow(bwimg);


rep = input('Press any key to close all figures, clear all variables and finish...', 's');
close all; clear all;
