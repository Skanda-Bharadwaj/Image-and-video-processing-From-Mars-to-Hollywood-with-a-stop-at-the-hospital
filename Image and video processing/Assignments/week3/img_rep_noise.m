function [ ni, err ] = img_rep_noise( img, N, sigma )
%IMG_REP_NOISE Apply the Gaussian noise to the specified image N times
% 
% Input:
%   img   - a matrix with image's pixels
%   N     - number of Gaussian noises to add to the image
%   sigma - standard deviation of the normally distributed noise
%
% Return:
%   ni  - image with added Gaussian noise
%   err - differences between the original and noisy images' pixels


% Maximum value of a pixel:
maxp = 255;

% Dimension of the image:
[ rows, cols ] = size(img);

% Copy 'img' to 'ni'...
ni = double(img);

% Apply the Gaussian noise (mu=0, s=sigma) for N times:
for i = 1 : N
    ni = ni + sigma * randn(rows, cols);
end  % for i


% Ensure that that ni's pixel values remain in the interval 0..maxp
ni(ni<0) = 0;
ni(ni>maxp) = maxp;

% And finally convert pixels to integers:
ni = uint8(ni);

% pixel errors:
err = int16(img) - int16(ni);

end
