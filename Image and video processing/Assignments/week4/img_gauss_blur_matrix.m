function [ h ] = img_gauss_blur_matrix( n, sigma )
%IMG_GAUSS_BLUR_MATRIX returns the Gaussian low pass filter matrix
%   This function is equivalent to fspecial('gaussian', n, sigma)
% 
% Input:
%   n     - size of the matrix
%   sigma - standard deviation
%
% Return:
%   h - Gaussian low pass filter matrix


h = zeros(n, n);
n0 = floor(n/2) + 1;
s2 = sigma * sigma;


%
%                                  x^2 + y^2
%                              - -------------
%                  1              2 * sigma^2
%   h(x,y) = -------------- * e    
%             2*pi*sigma^2
%


for x = 1 : n
    for y = 1 : n
        h(x, y) = exp( -( (x-n0)^2 + (y-n0)^2 ) / (2*s2) ) / (2*pi*s2);
    end  % for y
end  % for x

end
