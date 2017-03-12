function [ it ] = img_inpainting_i_t( img )
%IMG_INPAINTING_I_T Obtains inpainting PDE's dI/dt for each pixel of the
%                   given image 'img'
%
% Input:
%   img - a matrix of image's pixels
%
% Return:
%   it - dI/dt (grad(Ixx+Iyy) * grad(I)^P) for each img's pixel


[ rows, cols ] = size(img);

% Laplacian operator mask:
%
% DI = d^2I/dx^2 + d^2I/dy^2 = Ixx + Iyy
%
%          +          +
%          | 0  1   0 |
%   mask = | 1  -4  1 |
%          | 0  1   1 |
%          +          +
%
LaplOp = [0, 1, 0; 1, -4, 1; 0, 1, 0];

% Perform Laplacian operator on each pixel:
limg = conv2(double(img), LaplOp, 'same');

% Preallocation of it
it = zeros(rows, cols);


% For each pixel...
for x = 1 : rows
    for y = 1 : cols
        % grad(L) of the current pixel:
        gl = [0, 0];
        % perpendicular grad(I) of the current pixel
        gi = [0; 0];
        
        % Note that a perpendicular vector of [x,y] can be either
        % [x,-y] or [-x, y].
        % Hence the x' component of grad(I) will be placed to gi(2) and the
        % y component into gi(1). Sign of one component will be reverted
        % later
        
        % Both gradients in x direction
        if ( x>1 && x<rows )
            gl(1) = (limg(x+1, y) - limg(x-1, y) ) / 2;
            gi(2) = ( double(img(x+1, y)) - double(img(x-1, y)) ) / 2;
        elseif ( x==1 )
            gl(1) = limg(x+1, y) - limg(x, y);
            gi(2) = double(img(x+1, y)) - double(img(x, y));
        else  % x==rows
            gl(1) = limg(x, y) - limg(x-1, y);
            gi(2) = double(img(x, y)) - double(img(x-1, y));
        end
        
        % and both gradients in y direction
        if ( y>1 && y<cols )
            gl(2) = (limg(x, y+1) - limg(x, y-1) ) / 2;
            gi(1) = ( double(img(x, y+1)) - double(img(x, y-1)) ) / 2;
        elseif ( y==1 )
            gl(2) = limg(x, y+1) - limg(x, y);
            gi(1) = double(img(x, y+1)) - double(img(x, y));
        else  % y==cols
            gl(2) = limg(x, y) - limg(x, y-1);
            gi(1) = double(img(x, y)) - double(img(x, y-1));
        end
    
        % Revert sign of one component of gi
        % TODO which one?
        gi(2) = -gi(2);
    
        %    dI
        %   ---- = grad(lapl(I)) * grad(I)^P
        %    dt
        %
        % where '^P' denotes a perpendicular vector and '*' denotes
        % inner (scalar) product of two vectors.
        it(x, y) = gl * gi;
        
    end  % for y
end  % for x


end
