function [ sh ] = img_unsharp_mask( img )
%IMG_UNSHARP_MASK Sharpens the image using the Laplacian operator
%
% Input:
%   img - a matrix of image's pixels
%
% Return:
%   sh - a matrix of sharpened image's pixels


% The mask that implement the Laplacian operator in both directions:
%
%              2         2
%             d f       d f
%    LP(f) = -----  +  -----
%               2         2
%             dx        dy

mask = [ 0,  1, 0; ...
         1, -4, 1; ...
         0,  1, 0 ];

% Dimension of the original image
[ rows, cols ] = size(img);

% Preallocate 'sh'
sh = double(img);

% Implement LApalacian operator (and add it to the original pixels' values)
% for all img's pixels except all 4edges
for x = 2 : (rows-1)
    for y = 2 : (cols-1)
        sh(x, y) = double(img(x, y)) + ...
            sum(sum( double(img((x-1) : (x+1), (y-1) : (y+1))) .* mask ));
    end  % for y
end  % for x

sh = uint8( sh );

end
