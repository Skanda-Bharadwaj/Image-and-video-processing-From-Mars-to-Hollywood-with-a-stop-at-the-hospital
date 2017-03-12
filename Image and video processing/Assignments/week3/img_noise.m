function [ N ] = img_noise( img, sigma )
%IMG_NOISE Add Gaussian (normally distributed) noise to the image
%
% Input:
%   img   - a matrix of image's pixels
%   sigma - standard deviaton of the normally distributed noise
%
% Return:
%   N - image with added Gaussian noise

% Maximum value of a pixel:
maxp = 255;

% Dimension of the image:
[ rows, cols ] = size(img);

% Copy 'img' to 'N'...
N = double(img);

% ... and add Gaussian noise with mean=0 and st. dev = sigma
N = N + sigma * randn([rows, cols]);

% Ensure that that N's pixel values remain in the interval 0..maxp
N(N<0) = 0;
N(N>maxp) = maxp;

% And finally convert pixels to integers:
N = uint8(N);

end
