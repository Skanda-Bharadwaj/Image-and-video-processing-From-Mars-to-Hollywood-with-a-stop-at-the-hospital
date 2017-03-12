% Test tasks for the Week 1

clear all;  close all;  clc;

% Load the image:
img = imread('../lena512.pgm');

% Display the image:
disp('Figure 1: the original image')
figure(1);
imshow(img);

rep = input('Press any key to continue...', 's');

% Reduce image's intensity level
disp('Figure 2: Reduced the image''s intensity level by 2...');
im = reduce_img_intensity(img, 2);
figure(2);
imshow(im);

disp('Figure 3: Reduced the image''s intensity level by 16...');
im = reduce_img_intensity(img, 16);
figure(3);
imshow(im);

disp('Figure 4: Reduced the image''s intensity level by 32...');
im = reduce_img_intensity(img, 32);
figure(4);
imshow(im);

rep = input('Press any key to continue...', 's');

close(figure(2)); close(figure(3)); close(figure(4));

% Blurring of the image

disp('Figure 2: Image blurred by averaging pixels to their 3x3 neghbourhood');
im = avg_neighbourhood(img, 1);
figure(2);
imshow(im);

disp('Figure 3: Image blurred by averaging pixels to their 10x10 neghbourhood');
im = avg_neighbourhood(img, 5);
figure(3);
imshow(im);

disp('Figure 4: Image blurred by averaging pixels to their 20x20 neghbourhood');
im = avg_neighbourhood(img, 10);
figure(4);
imshow(im);

rep = input('Press any key to continue...', 's');

close(figure(2)); close(figure(3)); close(figure(4));

% Rotation of the image

disp('Figure 2: Image rotated by 45 deg counterclockwise');
im = imrotate(img, 45);
figure(2);
imshow(im);

disp('Figure 3: Image rotated by 90 deg counterclockwise');
im = imrotate(img, 90);
figure(3);
imshow(im);

rep = input('Press any key to continue...', 's');

close(figure(2)); close(figure(3));

% Reduction of the image's spatial resolution

disp('Figure 2: Spatial reduction of the image by averaging 3x3 blocks');
im = reduce_img_res(img, 3);
figure(2);
imshow(im);

disp('Figure 3: Spatial reduction of the image by averaging 5x5 blocks');
im = reduce_img_res(img, 5);
figure(3);
imshow(im);

disp('Figure 4: Spatial reduction of the image by averaging 7x7 blocks');
im = reduce_img_res(img, 7);
figure(4);
imshow(im);

rep = input('Press any key to close all figures, clear all variables and finish...', 's');

close all; clear all;
