function [ sgmt ] = img_active_contour( img, Phi0, dt, Nmax )
%IMG_ACTIVE_CONTOUR Active contour algorithm for segmentation of an image
% 
% Input:
%   img  - a matrix of grayscale image's pixels
%   Phi0 - initial values of levels. It must be greater then 0
%          inside the initial curve and less than 0 outside the curve
%   dt   - time step
%   Nmax - maximum number of steps
%
% Return:
%   sgmt - a logical matrix with elemnts inside the final curve equal to 1


[ rows, cols ] = size(img);

% img and Ph0 must be of the same size:
s0 = size(Phi0);
if ( rows~=s0(1) || cols~=s0(2) )
    error('Sizes of ''img'' and ''Phi0'' must match');
end


% Some hardcoded parameters
% TODO sholuld some of these values be passed as input arguments?
Gn = 1;            % Neighbourhood of the smoothing matrix
Sigma = 0.5;       % Standard deviation for Gaussian smoothing
beta = 1;          % A parameter for calculation of gradients


% Smoothing using the Gaussian filter:
%
%   gs = G_sigma * I
%
% where '*' denotes the 2D convolution
gs = conv2(double(img), fspecial('gaussian', Gn*2+1, Sigma), 'same');

% Preallocation of 'g'
g = zeros(rows, cols);

% This section actually detects edges in the original image. The result
% must be a matrix with elements somewhatproportional to 1 / |grad(gs)|
% Additional 1 is added in the denominator to prevent possible divisions by
% zero.
%
%                        1
%   g(x,y) = ---------------------------
%             1 + beta * | grad(gs) |^2
%
for x = 1 : rows
    for y = 1 : cols
        
        if ( x>1 && x<rows )
            gx = ( gs(x+1, y) - gs(x-1, y) ) / 2;
        elseif ( x==rows )
            gx = gs(x, y) - gs(x-1, y);
        else  % x==1
            gx = gs(x+1, y) - gs(x, y);
        end
        
        if ( y>1 && y<cols )
            gy = ( gs(x, y+1) - gs(x, y-1) ) / 2;
        elseif ( y==cols )
            gy = gs(x, y) - gs(x, y-1);
        else  % y==1
            gy = gs(x, y+1) - gs(x, y);
        end
        
        % Note that |grad(gs)|^2 is actually equal to gx^2+gy^2 :
        g(x, y) = 1 / ( 1 + beta * (gx*gx + gy*gy) );

    end  % for y
end  % for x

% The level set algorithm will also require gradients of g for each spatial
% element. The matrix will be calculated once and the values reused
% whenever necessary. Note that 'gr' is a 3D matrix, with the 3rd dimension
% of size 2. gr(:, :, 1) represents gradients' x components, gr(:, :, 2)
% their y components.
gr = zeros(rows, cols, 2);

for x = 1 : rows
    for y = 1 : cols
        if ( x>1 && x<rows )
            gx = ( g(x+1, y) - g(x-1, y) ) / 2;
        elseif ( x==rows )
            gx = g(x, y) - g(x-1, y);
        else  % x==1
            gx = g(x+1, y) - g(x, y);
        end
        
        if ( y>1 && y<cols )
            gy = ( g(x, y+1) - g(x, y-1) ) / 2;
        elseif ( y==cols )
            gy = g(x, y) - g(x, y-1);
        else  % y==1
            gy = g(x, y+1) - g(x, y);
        end
        
        gr(x, y, 1) = gx;
        gr(x, y, 2) = gy;
    end  % for y
end  % for x

% Initialize the matrix phi
phi = Phi0;

% For each step...
% TODO the algorithm should proceed until the whole matrix phi converges to
%      a steady state, i.e. d phi/dt = 0 for all elements of phi
for i = 1 : Nmax
    % Previous values of 'phi' will be necessary to obtain
    % spatial partial derivatives
    phip = phi;
    
    % For each phi's spatial element (a.k.a. pixel)...
    for x = 1 : rows
        for y = 1 : cols
            
            % First obtain both first order partial derivatives
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
            else  % y==1
                uy = phip(x, y+1) - phip(x, y);
            end
            
            % If the gradient of 'phi' equals 0, d phi/dt would also equal
            % 0 and phi would not be updated. For that reason just skip the
            % rest of the code for this pixel.
            if ( (ux*ux+uy*uy) < eps )
                continue;  % skip to the next pixel
            end  % if
            
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
            
            
            %  d phi
            % ------- = 
            %   dt
            %         phi_xx * phi_y^2 - 2 * phi_xy * phi_x * phi_y + phi_yy * phi_x^2
            %      = ------------------------------------------------------------------ +
            %                                  phi_x^2 + phi_y^2                     
            %
            %        +  gx * phi_x + gy * phi_y
            %
            term = g(x, y) * ...
                (uxx * uy *uy + uyy * ux *ux - 2 * ux * uy * uxy) / (ux*ux + uy*uy) + ...
                gr(x, y, 1) * ux + gr(x, y, 2) * uy;
            
            % Update phi using the Euler method:
            phi(x, y) = phi(x, y) + dt * term;
            
            % TODO consider other ODE solving methods, 
            % for instance one of Adams - Bashforth multistep methods
            
        end  % for y
    end  % for x
    
    % TODO break the loop if the maximum derivative w.r.t. t is below a
    % threshold
end  % for i

% Return value:
sgmt = phi >= 0;

end
