function [ image ] = img_inv_transform( T, method )
%IMG_INV_TRANSFORM Transforms the transform (typically DCT) to an image.
%   Splits the transform into 8x8 blocks, on each block, inverse DCT (either
%   the built-in function or own implementation) or FFT is applied.
%   Any transform's dimension is truncated if it is not a multiplier of 8.
%
% Input:
%   T      - a matrix with the transform's coefficients
%   method - transform to be performed on 8x8 blocks:
%            (0: built-in IDCT2, 1: own implementation of IDCT2, 3: IFFT2)
%
% Return:
%   image - a matrix with image's pixels
%
% An error is reported if 'method' is invalid.


    

% size of a block (NxN)
N = 8;

% image's dimension
[rows, cols] = size(T);

% Number of 8x8 blocks
NR = floor( rows / N );
NC = floor( cols / N );

% Preallocation of T
image = zeros(NR * N, NC * N);


% Precalculated table of cosines:
%   c(x, u) = cos((2*x-1)*(u-1)*pi/(2*N))
c = zeros(N, N);

if ( method == 1 )
    % The table of cosines is actually only necessary if method==1
    for i = 1 : N
        for j = 1 : N
            % note that matrix indices are 1-based!
            c(i, j) = (2*i-1)*(j-1)*pi/(2*N); 
        end  % for j
    end  % for i
    
    c = cos (c);
end  % if method

sq2= sqrt(2);

% For each 8x8 block...:
for i = 1 : NR
    for j = 1 : NC
        % submatrix for the corresponding 8x8 block
        subm = double(T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));

        if ( method == 0 )
             % built-in IDCT2:
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = idct2(subm);

        elseif ( method == 1 )
            % own implementation of IDCT2
            B = zeros(N, N);
             
            % Calculate B(x,y) as described in the lecture 4 (week 2)
            for x = 1 : N
                for y = 1 : N
                    B(x, y) = 0;
            
                    for u = 1 : N
                        for v = 1 : N
                            term = subm(u, v) * c(x, u) * c(y, v) * 2 / N;
                            
                            % normalization (multiplication by
                            % alpha(u)*alpha(v)):
                            if ( u == 1 )
                                term = term / sq2;
                            end  % if
                            if ( v == 1 )
                                term = term / sq2;
                            end  % if
                            
                            B(x, y) = B(x, y) + term;
                        end  % for v
                    end  % for u
                end  % for y
            end  % for x
            
            
            % Finally copy B into the corresponding region of T:
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = B;
            
        elseif ( method == 2 )
            % built-in FFT
            image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = real(ifft2(subm));

        else
            error('Invalid method');
        end  % if method

    end  % for j
end  % for i



image = uint8( round(image) );

end
