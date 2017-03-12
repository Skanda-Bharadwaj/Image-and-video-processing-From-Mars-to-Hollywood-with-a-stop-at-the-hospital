function [ nimg ] = img_draw_ellipses( img, pe, qe, ae, be, thetae )
%IMG_DRAW_ELLIPSES Draws detected ellipses to the original image
%
% Input:
%   img    - a matrix of original image's binary pixels
%   pe     - x coordinates of ellipses' centers
%   qe     - y coordinates of ellipses' centers
%   ae     - major radii of ellipses
%   be     - minor radii ellipses
%   thetae - angles of ellipses' major axes (relative to x)
%
% Return:
%   nimg - a matrix of grayscale (uint8) image's pixels with additional
%          detected circles in gray

% Grayscale value of the displayed ellipses
PV = uint8(128);

% Preallocate nimg and convert it to uint8
nimg = uint8( img ) * 255;

% Dimensions of 'img'
[ rows, cols ] = size( nimg );

% Traverse all values of input vectors
for i = 1 : min([length(pe), length(qe), length(ae), length(be), length(thetae)])
    p = pe(i);
    q = qe(i);
    a = ae(i);
    b = be(i);
    th = thetae(i);
    
    %
    % General equation of an ellipse, centered at (p,q), major radius 'a',
    % minor radius 'b' and 'th' being the angle between x and the major axis
    %
    %   [(x-p)*cos(th)] + (y-q)*sin(th)]^2     [-(x-p)*sin(th) + (y-q)*cos(th)]^2
    %  ------------------------------------ + ------------------------------------ = 1 
    %                  a^2                                    b^2
    %
    % The following quadratic equation or (y-q) can be derived from this general
    % equation:
    %
    %  qa * (y-q)^2 + qb * (y-q) + qc = 0
    %
    % where:
    %   qa = b^2 * cos^2(th) + a^2 * sin^2(th)
    %
    %   qb = (x-p) * sin(2*th) * (b^2 - a^2)
    %
    %   qc = (x-p)^2 * (b^2 * sin^2(th) + a^2 * cos^2(th)) - a^2 * b^2
    %
    % Then the discrimanat canbe calculated as:
    % 
    %   D = qb^2 - 4*qa*qc
    %
    % If the discriminant is non-negative, both y's can be obtained as:
    %
    %   y1 = q + (-qb + sqrt(D)) / (2*qa)
    %   y2 = q + (-qb - sqrt(D)) / (2*qa)
    %
    
    sth2 = sin(th)^2;
    cth2 = cos(th)^2;
    s2th = sin(2*th);
    
    % x on an ellipse will always be within the range:
    % (a-r) <= x <= (a+r)
    % provided that 'a' is the major radius
    for x = max(1, p-a) : min(rows, p+a)
        qa = b*b*cth2 + a*a*sth2;
        qb = (x-p) * s2th * (b*b - a*a);
        qc = (x-p)^2 * (b*b*sth2+a*a*cth2) - a*a*b*b;
        
        D = qb*qb - 4*qa*qc;
        if ( D < 0 )
            continue;  % for x
        end  % if
        
        y1 = q + (-qb + sqrt(D)) / (2*qa);
        y2 = q + (-qb - sqrt(D)) / (2*qa);
        
        % If any 'y' is within the image's range, plot points as a gray pixels
        if ( y1 <= cols )
            nimg(uint16(x), uint16(y1)) = PV;
        end  % if
        
        if ( y2 >= 1 )
            nimg(uint16(x), uint16(y2)) = PV;
        end  % if
        
    end  % for x
    
end  % for i

end
