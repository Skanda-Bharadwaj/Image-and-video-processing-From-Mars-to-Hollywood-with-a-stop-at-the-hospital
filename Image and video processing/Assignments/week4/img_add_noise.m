function [ nimg ] = img_add_noise( img, type, level )
%IMG_ADD_NOISE Adds Gaussian or salt & pepper noise to the given image
%
% Input:
%   img   - a matrix of image's pixels
%   type  - typo of noise. =: Gaussian noise, 1: salt & pepper noise
%   level - for type==0: variance of the Gaussian noise
%           for type==1: noise density, should be less than 1
%
% Return:
%   nimg - a matrix of noisy image's pixels


if ( type == 0 )
    % Gaussian noise
    nimg = imnoise(img, 'gaussian', 0, level);
elseif ( type == 1 )
    % Salt and pepper noise
    nimg = imnoise(img, 'salt & pepper', level);
else
    error('Unknown type of noise');
end  % if

end
