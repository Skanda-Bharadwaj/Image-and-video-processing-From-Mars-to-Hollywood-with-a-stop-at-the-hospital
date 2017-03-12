function [ fimg ] = img_nlmeans( img, r, f, h )
%IMG_NLMEANS Non-local means denoising of an image
%
% Input:
%   img   - a matix of noisy image's pixels
%   r     - size of the research neighbourhood
%   f     - size of the comparison window
%   h     - degree of filtering
%
% Return:
%   fimg - a matrix of filtered image's pixels


% The algorithm is described in detail at:
% https://en.wikipedia.org/wiki/Non-local_means
% See also: http://www.ipol.im/pub/art/2011/bcm_nlm/

nf = 2 * f + 1;
f2 = nf * nf;

% Local means of each pixel:
Om = conv2( double(img), ones(nf, nf)/f2, 'same' );

[rows, cols ] = size(img);

% Preallocate 'fimg'
fimg = zeros(rows, cols);

h2 = h * h;

for x = 1 : rows
    for y = 1:cols
        
        % Ensure that pixel's rxr neighbourhood will not reach out of img's range
        rx1 = max( x-r, 1 );
        rx2 = min( x+r, rows );
        ry1 = max( y-r, 1 );
        ry2 = min( y+r, cols );
        
        % Subtract current pixel's local mean from local means of all
        % pixels within the research neighbourhood:
        R = Om( rx1 : rx2, ry1 : ry2 ) - Om(x, y);
        
        % And obtain "weights" to all pixels within the research neighbourhood
        w = exp( -(R .* R) / h2 );
        
        % Calculate the weighted sum of all pixels
        up = sum(sum( double(img(rx1 : rx2, ry1 : ry2)) .* w ));
        
        % and finaly normalize it
        fimg(x, y) = up / sum(sum(w));

    end  % for y
end  % for x

% Convert 'fimg' to uint8:
fimg = uint8( fimg );

end
