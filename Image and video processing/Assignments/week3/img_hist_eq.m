function [ T ] = img_hist_eq( img )
%IMG_HIST_EQ Equalization of image's histogram
% The result is an image with the increased contrast.
% 
% Input:
%   img - a matrix with original image's pixels
%
% Return:
%   T - an image with the adjusted histogram


% Number of all possible pixel values
L = 256;

% Preallocates T
T = img;

% Original image's histogram
H = img_hist(img);

% Convertes the histograminto relative frequencies (probabilities)
s = sum(H(2,:));
p = double(H(2,:)) / double(s);

% Preallocates the map matrix
% (note: only its second row will actually be used)
m = uint8(zeros(2, L));
m(1, :) = 0 : (L-1);

% sum of all probabilities between 0 and the current i
% (a.k.a cumulative distribution function)
cdf = 0;

% Obtains cdf for each pixel value and the new value it maps to
%
%             i
%           -----
%           \
%   cdf(i) = >    p(w)
%           /
%           -----
%            w=0
%
%
%   m(i) = cdf(i) * (L-1) 
%
for i = 0 : (L-1)
    cdf = cdf + p(i+1);
    m(2, i+1) = uint8( (L-1) * cdf );
end  % for i


% Finally map each img's pixel to the adjusted one:
[ rows, cols ] = size(img);

for x = 1 : rows
    for y = 1 : cols
        T(x, y) = m(2, img(x, y)+1);
    end  % for y
end  %for x

end
