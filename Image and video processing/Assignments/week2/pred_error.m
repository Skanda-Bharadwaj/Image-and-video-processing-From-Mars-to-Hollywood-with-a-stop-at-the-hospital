function [ E ] = pred_error( image, method )
%PRED_ERROR MAtrix of prediction errors for each pixel
% 
% Input:
%   image  - a matrix with image's pixels
%   method - prediction method (0: predict from the left neighbour,
%            1: predict from the right neighbour, 
%            2: predict from left, right and lower left neighbours)
%
% Return:
%   E- matrix with prediction errors (predicted - actual pixel value)
%
% An error is reported if 'method' is invalid.

% Dimension of the image:
[rows, cols] = size(image);

% Preallocate E
E = int16(zeros(rows, cols));

% For each pixel,...
for x = 1 : rows
    for y = 1 : cols
        % Obtain its predicted value, based on 'method'.
        % Note, ifa any neighbour is out of image's range, it
        % will be set to 0
        
        p = 0;
        
        if ( method == 0 )
            % Predicted value is pixel's left neighbour:
            if ( y > 1)
                p = image(x, y-1);
            end  % if y
            
        elseif ( method == 1 )
            % Predicted value is pixel's right neighbour:
            if ( y < cols )
                p = image(x, y+1);
            end  % if y
            
        elseif ( method == 2 )
            % Predicted value is rounded average of pixel's left, right 
            % and lower left neighbour:
            n = 0;
            if ( y>1 )
                p = p + image(x, y-1);
                n = n + 1;
            end  % if y
            
            if ( y < cols )
                p = p + image(x, y+1);
                n = n + 1;
            end  % if x
            
            if ( y>1 && x<rows)
                p = p + image(x+1, y-1);
                n = n + 1;
            end  % if
            
            % average of all valid neighbours
            p = round(p / n);
            
        else
            error('Invalid method');
        end  % if method
     
        % error = prediction - actual value:
        E(x, y) = int16(p) - int16(image(x, y));
        
    end  % for y
end  % for x

end
