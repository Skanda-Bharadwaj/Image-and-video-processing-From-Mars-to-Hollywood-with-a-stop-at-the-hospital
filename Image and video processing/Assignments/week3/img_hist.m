function [ H ] = img_hist( img )
%IMG_HIST Creates a histogram of an image
%
% Input:
%   img - a matrix with image's pixels
%
% Returns:
%   H - a 2x256 matrix, the first rows contains the actual pixel values,
%       the second row contains their number of occurrences


% Number of possible pixel values
L = 256;

% Preallocate H
H = uint32(zeros(2, L));
H(1, :) = 0 : (L-1);


% This for loop actually counts the number of occurrences of each 'i' by
% summing of all ones in the matrix img==i, where ones only occur where
% img(x,y)==i
for i = 0 : (L-1)
    H(2, i+1) = sum(sum( img==i ));
end  % for i

end
