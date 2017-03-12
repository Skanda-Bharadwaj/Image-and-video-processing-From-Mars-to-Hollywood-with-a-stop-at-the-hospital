function [ Ht, a, b, r ] = img_hough_circle( img )
%IMG_HOUGH_CIRCLE Performs Hough transformation on 'img' and extracts
%                 possible circles
%
% Input:
%   img - a matrix of original (binary!!!) image's pixels
%
% Return:
%   Ht - a 3D matrix of Hough transform's components (row, column, radius)
%   a  - a vector of circles' centers' ordinates
%   b  - a vector of circles' centers' abscissae
%   r  - a vector of circles' radii

% Dimensions of 'img'
[rows, cols ] = size(img);

% ranges of each parameter (depends on an application)
% TODO should this be passed as input arguments???
a = 1 : rows;
b = 1 : cols;
r = 10 : 2 : min(rows, cols);

% Preallocate Ht
Ht = zeros( length(a), length(b), length(r) );

% For all valid combinations of circle's parameters a, b and r....
for aidx = 1 : length(a)
    p = a(aidx);
    for bidx = 1 : length(b)
        q = b(bidx);
        for ridx = 1 : length(r)
            rho = r(ridx);
            
            % x (ordinate) of a given circle will always be within the
            % interval:
            % (a-r) < x < (a+r)
            %
            % From the circle's equation:
            %        2        2    2
            %   (x-a)  + (y-b)  = r
            % one can quickly obtain its corresponding pair of y (abscissae):
            %
            %   y = b +/- sqrt(r^2 - (x-a)^2)
            
            % For each valid x (i.e. between 1 and rows)...
            for x = max(1, p-rho) : min(rows, p+rho)
                % obtain both y's
                yp = sqrt(rho*rho - (x-p)*(x-p));
                y1 = q + yp;
                y2 = q - yp;
                
                % If the point is within the image's range,
                % check if it belongs to the circle (its value is different than 0)
                if ( y1 <= cols && 1==img(uint16(x), uint16(y1)) )
                    % IF it does, increment the corresponding element of Ht
                    Ht(aidx, bidx, ridx) = Ht(aidx, bidx, ridx) + 1;
                end  % if
                
                % The same procedure for the other y:
                if ( y2 >= 1 && 1==img(uint16(x), uint16(y2)) )
                    Ht(aidx, bidx, ridx) = Ht(aidx, bidx, ridx) + 1;
                end  % if
                
            end  % for x
     
        end  % for ridx
    end  % for bidx
end  % for aidx

end
