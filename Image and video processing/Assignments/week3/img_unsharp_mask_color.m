function [ csh ] = img_unsharp_mask_color( cimg )
%IMG_UNSHARP_MASK_COLOR Sharpens a color image using the LAplacian operator
%
% Input:
%   cimg - a matrix of color image's pixels
%
% Return:
%   csh - a matrix of sharpened image's pixels

% Preallocate csh
csh = cimg;

% Apply unsharpening (already implemented by img_unsharp_mask)
% for each color channel
for d = 1 : 3
    csh( :, :, d) = img_unsharp_mask( cimg( :, :, d) );
end  % for d

end
