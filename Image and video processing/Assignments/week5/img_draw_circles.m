function [ nimg ] = img_draw_circles( img, Ht, a, b, r, N )
%IMG_DRAW_CIRCLES Draws detected circles to the original image
% 
% Input:
%   img - a matrix of original image's binary pixels
%   Ht - a 3D matrix of Hough transform's components (row, column, radius)
%   a  - a vector of circles' centers' ordinates
%   b  - a vector of circles' centers' abscissae
%   r  - a vector of circles' radii
%   N  - the N.th largest value to determine the threshold
%
% Return:
%   nimg - a matrix of grayscale (uint8) image's pixels with additional
%          detected circles in gray

PV = uint8(128);

% Preallocate nimg and convert it to uint8
nimg = uint8( img ) * 255;

% Dimensions of the original image:
[ rows, cols ] = size( img );

% Sort all values of Ht in descending order
cidx = sort(reshape(Ht, [1, numel(Ht)]), 'descend');
% and determine the threshold:
th = cidx(N);

% Indices of all elements that are greater than the the threshold:
[ ia, ib, ir ] = ind2sub(size(Ht), find(Ht>=th));

% TODO filter out similar circles

% For each circle that exceeds the threshold...
for i = 1 : length(ia);
    % Occasionally uncommented for "debugging" purposes:
    %fprintf('%d: (%f, %f, %f)\n', i, a(ia(i)), b(ib(i)), r(ir(i)));
    
    % Draw a circle:
    % From the circle's equation:
    %
    %        2        2    2
    %   (x-a)  + (y-b)  = r
    %
    % One can quickly obtain a pair of y's from the given x:
    %
    %   y = b +/- sqrt(r^2 - (x-a)^2)
    
    % For better readability, assign these auxiliary variables from indeces:
    p = a(ia(i));       % ordinate of the center
    q = b(ib(i));       % abscissa of the center
    rho = r(ir(i));     % radius
    
    % x on a circle will always be within the range:
    % (a-r) <= x <= (a+r)
    for x = max(1, p-rho) : min(rows, p+rho)
        sq = sqrt( rho^2 - (x-p)^2 );
        y1 = q + sq;
        y2 = q - sq;
        
        % For both points (x,y1) and(x,y2) check if they are within the
        % image's range. If they are, paint the corresponding pixel as gray
        if ( y1 <= cols )
            nimg(uint16(x), uint16(y1)) = PV;
        end  % if
        
        if ( y2 >= 1 )
            nimg(uint16(x), uint16(y2)) = PV;
        end  % if
        
    end  % for x
end  % for i

end
