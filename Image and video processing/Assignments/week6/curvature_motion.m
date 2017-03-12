function curvature_motion( img, v, dt, N )
%CURVATURE_MOTION Curvature motion of the image
%
% Input:
%   img - a matrix of iamge's pixels
%   v   - speed of the curvature motion
%   dt  - time step
%   N   - number of steps


% This implementation uses the explicit finite difference schem to evaluate
% the curvature. It is explained in detail at:
%
%    Robert Eymard, Angela Handlovicova, Karol Mikula
%    Non-diffusive Numerical Scheme for Regularized Mean Curvature Flow Level 
%         Set Equation in Image Processing
%    Proceedings of the 3rd International Congress on Image and Signal Processing (CISP),
%    vol. 2, pp. 748 - 753, 2010, Yantai
% 
% The article is available at:
% http://www.math.sk/mikula/EHM-CISP-BMEI10.pdf



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


% For each step
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
            %    d phi
            %   ------- = v * K * | grad(phi) |              ( 1 )
            %     dt
            %
            % The curvature (kappa, K) can be expressed as:
            %
            %           /    grad(phi)    \
            %   K = div | --------------- |                  ( 2 )
            %           \  | grad(phi) |  /
            %
            % As explained in the article, the expression 1 can be
            % rewritten as
            %
            %
            %    d phi         phi_xx*phi_y^2 + phi_yy*phi_x^2 - 2*phi_x*phi_y*phi_xy
            %   ------- = v * --------------------------------------------------------    ( 3 )
            %     dt                           phi_x ^ 2 + phi_y ^ 2
            %
            % where phi_x, phi_yy, phi_xx, phi_yy and phi_xy denote
            % 1st or 2nd order partial derivatives of phi w.r.t.
            % variable(s) in the index.
            %
            % To evalutae partial derivatives, the finite difference method
            % is used, as suggested in the article.
            % If possible, the derivatives are evaluated as the
            % central difference. When this is not possible (i.e. for pixels
            % on any edge), either anappropriate form of the forward or backward
            % difference is used.

            
            % Both first order partial derivatives:
            if ( x>1 && x<rows )
                ux = ( phip(x+1, y) - phip(x-1, y) ) / 2;
            elseif ( x==rows )
                ux = phip(x, y) - phip(x-1, y);
            else  % x==1
                ux = phip(x+1, y) - phip(x, y);
            end
            
            if ( y>1 && y<cols )
                uy = ( phip(x, y+1) - phip(x, y-1) ) / 2;
            elseif ( y==cols )
                uy = phip(x, y) - phip(x, y-1);
            else  %y==1
                uy = phip(x, y+1) - phip(x, y);
            end
            
            
            % Both second order partial derivatives:
            if ( x>1 && x<rows )
                uxx = phip(x+1, y) - 2*phip(x, y) + phip(x-1, y);
            elseif ( x==rows )
                uxx = phip(x, y) - 2*phip(x-1, y) + phip(x-2, y);
            else  % x==1
                uxx = phip(x+2, y) - 2*phip(x+1, y) + phip(x, y);
            end
            
            if ( y>1 && y<cols )
                uyy = phip(x, y+1) - 2*phip(x, y) + phip(x, y-1);
            elseif ( y==cols )
                uyy = phip(x, y) - 2*phip(x, y-1) + phip(x, y-2);
            else  % y==1
                uyy = phip(x, y+2) - 2*phip(x, y+1) + phip(x, y);
            end
            
            
            % And the mixed partial derivative that requires handling
            % situations when the pixel lies on any edge
            if ( x>1 && x<rows && y>1 && y<cols )
                uxy = ( phip(x+1, y+1) + phip(x-1, y-1) - ...
                        phip(x-1, y+1) - phip(x+1, y-1) )/ 4;
            elseif ( x==rows && y<cols )
                uxy = ( phip(x, y+1) - phip(x-1, y) ) / 2;
            elseif ( x==rows && y==cols )
                uxy = ( phip(x, y) - phip(x-1, y-1) ) / 2;
            elseif ( x<rows && y<cols )
                uxy = ( phip(x+1, y+1) - phip(x, y) ) / 2;
            elseif ( x<rows && y==cols )
                uxy = ( phip(x+1, y) - phip(x, y-1) ) / 2;
            else
                error('Unhandled situation');
            end
            
            
            % Finally update the 'phi' using the Euler's method.
            
            % Note: If both first order derivatives equal 0, the pixel
            % would not be updated anyway.
            if ( abs(ux)>eps || abs(uy)>eps )
                phi(x, y) = phi(x, y) + dt * v * ...
                    (uxx * uy * uy + uyy * ux * ux - 2 * ux * uy * uxy) / (ux*ux + uy*uy);
            end  % if

        end  % for y
    end  % for x
end  % for i

end
