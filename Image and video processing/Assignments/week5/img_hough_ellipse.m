function [ p, q, a, b, theta ] = img_hough_ellipse( img, minr, minvotes )
%IMG_HOUGH_ELLIPSE Performs Hough transformation on 'img' and extracts
%                  possible ellipses
% Input:
%   img      - a matrix of original (binary!!!) image's pixels
%   minr     - minimum minor or major radius to be considered
%   minvotes - minimum number of votes for the minor radius to be
%              considered
%
% Return:
%   p     - x coordinates of detected ellipses' centers
%   q     - y coordinates of detected ellipses' centers
%   a     - major radii of detected ellipses
%   b     - minor radii of detected ellipses
%   theta - angles of detected ellipses' major axes (relative to x)



% The general Hough transform requires voting on 5 paramaeters (two coordinates
% of ellipse's center, major and minor radius, angle of major radius
% relative to x), making the algorithm very inefficient. Instead a memory
% efficient algorithm is implemented, described in detail at:
%
%   Yonghong Xie, Qiang Ji,
%   A New Efficient Ellipse Detection Method
%   Proceedings of the 16th International Conference on Pattern Recognition - ICPR, 
%   vol. 2, pp. 957-960, 2002
%
% http://hci.iwr.uni-heidelberg.de/publications/dip/2002/ICPR2002/DATA/07_3_20.PDF


% All edge pixels
[x, y] = find(img);

% Empty vectors for output variables
p = [];
q = [];
a = [];
b = [];
theta = []; 


% Find all combinations of points and consider them as ellipse's vertices
for i1 = 1 : (length(x)-1)
    x1 = x(i1);
    y1 = y(i1);
    for i2 = (i1+1) : length(x)
        x2 = x(i2);
        y2 = y(i2);
        % MAjor redius = half the distance between both points
        aa = norm([x1-x2, y1-y2]) / 2;
        
        % The combination of points is only considered if the distance
        % between them is greater than the threshold
        if ( aa*2 < minr )
            continue;  % for i2
        end  % if
        
        % Potential center of the ellipse:
        x0 = ( x1 + x2 ) / 2;
        y0 = ( y1 + y2 ) / 2;
        
        % Angleof the major axis, relative to x
        alpha = atan2(y2-y1, x2-x1);
        
        % reset the accumulator
        acc = zeros(1, floor(aa)+1);
        
        % Now consider all the remaining points as a part of the ellipse
        for i = 1 : length(x)
            if ( i==i1 || i==i2 )
                continue;  % for i
            end  % if
            
            % distance of the point to the ellipse's center
            d = norm([x(i)-x0, y(i)-y0]);
            
            % only consider the point if 'd' is within a specified range
            if ( d > aa || d < minr )
                continue;  % for i
            end  % if
            
            % Distance between the point and the second vertex:
            f = norm([x(i)-x2, y(i)-y2]);
            
            %
            %             a^2 + d^2 - f^2 
            % cos(tau) = -----------------
            %                  2ad 
            %
            ct = (aa*aa + d*d - f*f) / (2*aa*d);
            ct2 = ct * ct;      % cos^2(tau)
            
            %
            % sin^2(tau) = 1 - cos^2(tau)
            %
            st2 = 1 - ct2;
            
            %
            %         a^2 d^2 sin^2(tau)
            % b^2 = ----------------------
            %        a^2 - d^2 cos^2(tau)
            %
            bb = sqrt( (aa*aa * d*d * st2) / (aa*aa - d*d*ct2) );
            
            % If 'bb' is within a valid range, increment the accumulator
            if ( bb >= 1 && bb <= aa )
                acc(uint16(bb)) = acc(uint16(bb)) + 1;
            end  % if
        end  % for i
        
        % Check if the accumulator's highest vote is greater than the
        % threshold:
        [ maxvotes, bmax ] = max(acc);
        if ( maxvotes < minvotes )
            continue;  % for i2
        end  % if
        
        % If yes, append ellipse's parameters to output variables:
        p = [ p ; x0 ];
        q = [ q ; y0 ];
        a = [ a ; aa ];
        b = [ b ; bmax ];
        theta = [ theta ; alpha ];
        
        % TODO collect "similar" ellipses and "join" them into the best
        % fitting one
        
    end  % for i2
end  % for i1
            
end
