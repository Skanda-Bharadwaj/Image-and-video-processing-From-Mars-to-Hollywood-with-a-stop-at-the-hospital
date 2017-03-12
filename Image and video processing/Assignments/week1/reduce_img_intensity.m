function [ img ] = reduce_img_intensity( image, level )
%REDUCE_IMG_INTENSITY reduces the number of intensity level of a 
%                     (greyscale) image
%
% Input:
%   image - a matrix of pixels
%   level - desired intensity level, must be a positive integer between 1
%           and 128 and must be a power of 2
%
% Return:
%   img - a matrix of reduced intensity image's pixels 
%
% An error is reported if 'level' is not valid



% Write a computer program capable of reducing the number of intensity
% levels in an image from 256 to 2, in integer powers of 2. The desired
% number of intensity levels needs to be a variable input to your program.


% level must be a positive integer and a power of 2
if ( floor(level)~=level | level <= 0 | level > 255 | level ~= pow2(nextpow2(level)) )
     
         error('Invalid intensity level');
end %if

% Each image's pixel is processed as follows:
%
%              |              |
%              |  image(x,y)  |
%   img(x,y) = | ------------ | * level 
%              |    level     |
%              +-            -+

img = floor(image/level) * level;

end
