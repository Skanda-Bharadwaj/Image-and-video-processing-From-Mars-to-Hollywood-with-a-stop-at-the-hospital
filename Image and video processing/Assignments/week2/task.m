% Test tasks for the Week 2

clear all; close all; clc;

% Load the image:
img = imread('../lena512.pgm');

% Display the image:
disp('Figure 1: the original image')
figure(1);
imshow(img);


% DCT transform:
timg = img_transform(img, 1);

% Quantizations:
% - by quantization matrix:
q1 = img_quantize(timg, 0, 0);

% - threshold (th=32):
q2 = img_quantize(timg, 1, 32);

% - threshold (th=16):
q3 = img_quantize(timg, 1, 16);

% - preserved 8 largest coefficients:
q4 = img_quantize(timg, 2, 0);

% FFT transform:
fimg = img_transform(img, 2);

% Quantization of FFT transform using the quantization matrix:
q5 = img_quantize(fimg, 1, 128);

% Inverse transforms of all  quantizations:
im1 = img_inv_transform(q1, 0);
im2 = img_inv_transform(q2, 1);
im3 = img_inv_transform(q3, 0);
im4 = img_inv_transform(q4, 1);
im5 = img_inv_transform(q5, 2);

% Display all compressed images:
disp('Figure 2: compressed using the quantization matrix:');
figure(2);
imshow(im1);

disp('Figure 3: compressed using the threshold 32:');
figure(3);
imshow(im2);

disp('Figure 4: compressed using the threshold 16:');
figure(4);
imshow(im3);

disp('Figure 5: compressed by preserving 8 largest DCT coefficients:');
figure(5);
imshow(im4);

disp('Figure 6: Fourier transformed image, compressed using the threshold 128:');
figure(6);
imshow(im5);


rep = input('Press any key to continue...', 's');
close(figure(2));  close(figure(3));  
close(figure(4));  close(figure(5));  close(figure(6));

% Apply quantization on the original image
im1 = img_quantize(img, 0, 0);
disp('Figure 2: Quantization of an image without performing DCT, use quantization matrix:')
figure(2);
imshow(im1);

im2 = img_quantize(img, 1, 32);
disp('Figure 3: Quantization of an image without performing DCT, use threshold 32:')
figure(3);
imshow(im2);

im3 = img_quantize(img, 1, 16);
disp('Figure 4: Quantization of an image without performing DCT, use threshold 16:')
figure(4);
imshow(im3);

im3 = img_quantize(img, 2, 0);
disp('Figure 5: Quantization of an image without performing DCT, use preservation of 8 largest values:')
figure(5);
imshow(im4);


rep = input('Press any key to continue...', 's');
close all;

% Compression of a color image:
colimg = imread('../lena512color.tiff');

disp('Figure 1: the original color image');
figure(1);
imshow(colimg);

rgb1 = img_color_compress(colimg, 8, 8);
disp('Figure 2: color image comprassed with quantization threshold of 8 for all channels');
figure(2);
imshow(rgb1);

rgb2 = img_color_compress(colimg, 8, 64);
disp('Figure 3: color image compressed with quantization threshold of 8 for the Y channel');
disp('          and 64 for both chrominance channels')
figure(3);
imshow(rgb2);


rep = input('Press any key to continue...', 's');
close all;


% Predicton methods:

disp('Figure 1: Prediction from pixel''s left neighbour:');
E = pred_error(img, 0);
eh = err_hist(E);
figure(1);
bar(eh(1,:), eh(2,:));
H = err_entropy(eh);
fprintf('Entropy: %f\n\n', H);

disp('Figure 2: Prediction from pixel''s right neighbour:');
E = pred_error(img, 1);
eh = err_hist(E);
figure(2);
bar(eh(1,:), eh(2,:));
H = err_entropy(eh);
fprintf('Entropy: %f\n\n', H);

disp('Figure 3: Prediction from pixel''s 3 neighbours:');
E = pred_error(img, 2);
eh = err_hist(E);
figure(3);
bar(eh(1,:), eh(2,:));
H = err_entropy(eh);
fprintf('Entropy: %f\n\n', H);

rep = input('Press any key to close all figures, clear all variables and finish...', 's');

close all; clear all;
