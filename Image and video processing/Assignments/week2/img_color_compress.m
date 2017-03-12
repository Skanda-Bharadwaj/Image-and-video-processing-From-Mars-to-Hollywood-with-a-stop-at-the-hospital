function [ C ] = img_color_compress( RGB, CY, CC )
%IMG_COLOR_COMPRESS Compresses color images with different compress ratios
% for Y and chrominance channels. Method 1 of 'img_quantize' is applied for
% quantization.
%
% Input:
%   RGB - a 3D matrix of pixels for red, green and blue channel, respectively
%   CY  - compression threshold for the Y channel
%   CC  - compression threshold for chrominance channels (Cb and Cr)
%
% Return:
%   C - a 3D matrix of compressed image's pixels for red, green and
%       and blue channels, respectively


% Convert the image from RGB to YCbCr:
Y = rgb2ycbcr(RGB);

% Preallocate C by setting all elements to 0
C = Y * 0;

% Each YCbCr's channel is DCT transformed, quantized and then
% transformed back from the DCT. The specified threshold is
% used for quantization of each channel
C( :, :, 1) = img_inv_transform(img_quantize(img_transform(Y(:, :, 1), 0), 1, CY), 0);
C( :, :, 2) = img_inv_transform(img_quantize(img_transform(Y(:, :, 2), 0), 1, CC), 0);
C( :, :, 3) = img_inv_transform(img_quantize(img_transform(Y(:, :, 3), 0), 1, CC), 0);

% Finally convert YCbCr back to RGB:
C = ycbcr2rgb(C);

end
