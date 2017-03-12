function [ h ] = err_hist( E )
%ERR_HIST Obtains a histogram of prediction errors
%
% Input:
%   E - matrix of prediction errors
%
% Return:
%   h - histogram as a 2 row matrix, the 1st row is filled with actual
%       values, the 2nd row with their number of occurrences

% Number of possible different pixel values in the original image
% TODO this should probably be an input argument
depth = 256;

% If a pixel in the originalimage can take any value between 0 and depth-1,
% error can theoretically be anything between -depth+1 and depth-1.
% These theoretical error values will be accordingly shifted into the
% matrix's row:

% Preallocate h a nd fill the 1st row with all theoretically possible error
% values:
h = zeros(2, 2*depth-1);
h(1, :) = (-depth+1) : (depth-1);

% Minimum and maximum error:
im_min = min(min(E));
im_max = max(max(E));

% This for loop actually counts number of occurrences of each 'v' by
% summing of all ones in the matrix E==v, where ones only occur where
% E(i,j)==v
for v = im_min : im_max
    h(2, depth + v) = sum(sum(E==v));
end  % for v

end
