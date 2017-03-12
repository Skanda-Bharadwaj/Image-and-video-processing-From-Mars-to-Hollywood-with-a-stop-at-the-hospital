% Test tasks for the Week 7
clear all; close all; clc;


% dI / dt for the given image
img = imread('../lena512.pgm');

figure(1);
disp('Figure 1: the original image');
imshow(img);

it = img_inpainting_i_t(img);
disp('Figure 2: inpainting PDEs'' dI/dt');
figure(2);
mesh(it);


rep = input('Press any key to continue...', 's');
close all;

% Video inpainting using the median of consecutive frames

% Animated GIF downloaded from:
% https://commons.wikimedia.org/wiki/File:SimpleAnimation.gif

v=imread('../SimpleAnimation.gif', 'frames', 'all');
vmed = median_inpaint(v,4);

disp('First video player: the original video');
implay(double(v), 1);
disp('Second video player: processed video with hthe white section inpainted');
implay(double(vmed), 1);


disp('Video players must be closed manually');
