function constant_motion( img, sign, dt, N )
%CONSTANT_MOTION Constant motion of the image
%                Motion direction depends on 'sign'
%
% Input:
%   img  - a matrix of iamge's pixels
%   sign - motion direction: if greater than 0, abs. of gradient is added to phi,
%          otherwise it is subtracted from phi
%   dt   - time step
%   N    - number of steps


% Dimensions of the image
[ rows, cols ] = size(img);

% The current image
phi = double(img);


% Among all possible integer divisors of N, find the pair that optimally
% divides 'N', i.e. it minimizes the sum of both divisors:

% The highest divisor will not be greater than sqrt(N):
D = 1 : floor(sqrt(N));
% all divisors of N that are lees or equal to sqrt(N):
d1 = D(~rem(N, D));
% their "complementary" divisors (d1 * d2 = N)
d2 = N ./ d1;
% and find a pair with the minimum sum d1+d2 
[~, i] = min(d1+d2);
% Number of rows in the subplot:
PR = d1(i);
% Number of columns in the subplot: 
PC = d2(i);


% A handle to the figure that will be further divided into PR x PC subplots
figure;

% For each step...
for i = 1 : N

    % plot the current phi
    subplot(PR, PC, i);
    imshow(uint8(phi));
    
    % No need to perform any calculations if i==N
    if ( i==N )
        break;
    end  % if
    
    % Previous phi, necessary to obtain gradients
    phip = phi;
    
    % Each pixel...
    for x = 1 : rows
        for y = 1 : cols
            
            % ... is updated according to the partial differential equation:
            %
            %    d phi        |           |
            %   ------- = +/- | grad(phi) |
            %     dt          |           |
            
            
            % ... obtain its gradient:
            %
            %                d phi          d phi
            %   grad(phi) = ------- * ex + ------- * ey
            %                  dx             dy
            %
            % where 'd' represents the partial derivative and
            % 'ex' and 'ey' represent unit vectors in each direction
            
            if ( x < rows )
                gx = phip(x+1, y) - phip(x, y);
            else
                gx = phip(x, y) - phip(x-1, y);
            end  % if
            
            if ( y < cols )
                gy = phip(x, y+1) - phip(x, y);
            else
                gy = phip(x, y) - phip(x, y-1);
            end  % if
            
            % Actually the absoulte value of the gradient vector 
            % (i.e. its norm) is required:
            g = norm([gx, gy]);
            
            % Finally update the phi, depending on the direction (sign).
            % Note, the Euler's method is implemented here.
            if ( sign > 0 )
                phi(x, y) = phi(x, y) + g * dt;
            else
                phi(x, y) = phi(x, y) - g * dt;
            end  % if
            
        end  % for y
    end  % for x
    
end  % for i

end
