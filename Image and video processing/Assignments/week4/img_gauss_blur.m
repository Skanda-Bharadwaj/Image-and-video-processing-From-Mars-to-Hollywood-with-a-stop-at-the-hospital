function [ bimg, h ] = img_gauss_blur( img, n, sigma )
%IMG_GAUSS_BLUR Blurs the givenimage using the Gaussian low pass filter
%
% Input:
%   img   - a matrix of image's pixels
%   n     - specifies filter's nxn neighbourhoud
%   sigma - standard deviation of the Gaussian filter
%
% Return:
%   bimg - a matrix of blurred image's pixels
%   h    - Gaussian low pass filter matrix

% Dimensions of 'img'
[ rows, cols ] = size(img);

% Preallocate 'bimg':
bimg = double( img );

% Gaussian low pass filter matrix:
%h = img_gauss_blur_matrix(n, sigma);
h = fspecial('gaussian', n, sigma);

% Number of pixels before and after the current point (for both
% dimensions):
nl = floor(n/2);
nh = n - 1 - nl;

% Convolution of the image and Gaussian filter.
% Note: edge pixels are currently not filtered.
for x = (nl+1) : (rows-nh)
    for y = (nl+1) : (cols-nh)
        bimg(x, y) = sum(sum( double(img( (x-nl) : (x+nh), (y-nl) : (y+nh) )) .* h ));
    end  % for y
end  % for x

% Convert 'bimg' to uint8
bimg = uint8(bimg);

end
