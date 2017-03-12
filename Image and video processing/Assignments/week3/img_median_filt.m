function [ mf ] = img_median_filt( img, N )
%IMG_MEDIAN_FILT Median filter of an image.
%
% Each pixel of the image is replaced by a median of pixel's
% [x-N : x+N, y-N : y+N] neighbourhood. Pixels out of the image's
% range are not considered by the filter.
%
% Input:
%   img - a matrix of image's pixels
%   N   - size of the pixel's neighbourhood.
%
% Return:
%   mf - a matrix with the filtered image's pixels


% Dimensions of the image
[ rows, cols ] = size(img);

% Preallocate mf:
mf = img * 0;

% For each img's pixel...
for x = 1 : rows
    for y = 1 : cols
        
         % make sure its (2n+1)x(2n+1) neighbourhood wil not reach out
         % of the image's range!
         x_lower = max([1, x-N]);
         x_upper = min([rows, x+N]);
         y_lower = max([1, y-N]);
         y_upper = min([cols, y+N]);
         
         % Finally replace the pixel by the median value
         % of the valid neighbourhood:
         mf(x, y) = median( ...
           reshape( img( x_lower : x_upper, y_lower : y_upper ), 1, ...
                    (x_upper - x_lower + 1)*(y_upper - y_lower + 1) ));
    end  % for y
end  % for x

end
