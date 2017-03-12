function [ img ] = avg_neighbourhood( image, n )
%AVG_NEIGHBOURHOOD Blurs the image by replacing each pixel by the average of its 
%          (2*n+1) x (2*n+1) neighbourhood. Pixels out of the image's range
%          will not count into the average.
% 
% Input:
%   image - a matrix of pixels
%   n     - neighbourhood; each pixel will be replaced by the average value
%           of its (i-n : i+n) x (j-n : j+n) neighbourhood
%
% Return:
%   img - a matrix with blurred image's pixels
%
% An error is reported if 'n' is not valid, i.e. a non-negative integer


% Using any programming language you feel comfortable with (it is though
% recommended to use the provided free Matlab), load an image and then perform
% a simple spatial 3x3 average of image pixels. In other words, replace the value
% of every pixel by the average of the values in its 3x3 neighborhood. If the
% pixel is located at (0,0), this means averaging the values of the pixels at the
% positions (-1,1), (0,1), (1,1), (-1,0), (0,0), (1,0), (-1,-1), (0,-1), and (1,-1). 
% Be careful with pixels at the image boundaries. Repeat the process for a 10x10
% neighborhood and again for a 20x20 neighborhood. Observe what happens to the image 
% (we will discuss this in more details in the very near future, about week 3).


% 'n' must be a non-negative integer
if ( n<0 | floor(n)~=n )
    error('Invalid n');
end %if

% image's size:
[rows, cols] = size(image);

% Create a matrix with the same dimensions
img = zeros(rows, cols);

% for each pixel...
for i = 1 : rows
    for j = 1 : cols
        % make sure its nxn neighbourhood wil not reach out
        % of the image's range!
        i_lower = max([1, i-n]);
        i_upper = min([rows, i+n]);
        j_lower = max([1, j-n]);
        j_upper = min([cols, j+n]);
        
        % Sum up all valid pixels of the nxn neighbourhood...
        img(i, j) = sum( sum( image(i_lower : i_upper, j_lower : j_upper) ) );
        % And divide by the number of the neighbourhood's valid pixels:
        img(i, j) = img(i, j) / ((i_upper - i_lower + 1)*(j_upper - j_lower + 1));
    end % for j
end % for i

% Finally round the pixels to integer values:
img = uint8( floor( img + 0.5 ) );

end
