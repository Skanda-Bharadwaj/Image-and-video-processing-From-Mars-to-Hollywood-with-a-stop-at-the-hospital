function [ T ] = img_transform( image, method )
%IMG_TRANSFORM Transforms the (grayscale) image
%   Splits the image into 8x8 blocks, on each block, DCT (either the built-in 
%   function or own implementation) or FFT is applied.
%   Any image's dimension is truncated if it is not a multiplier of 8.
%
% Input:
%   image  - a matrix of pixels
%   method - transform to be performed on 8x8 blocks:
%            (0: built-in DCT2, 1: own implementation of DCT2, 3: FFT2)
%
% Return:
%   T - transformation of the image
%
% An error is reported if 'method' is invalid.

% size of a block (NxN)
N = 8;

% image's dimension
[rows, cols] = size(image);

% Number of 8x8 blocks
NR = floor( rows / N );
NC = floor( cols / N );

% Preallocation of T
T = zeros(NR * N, NC * N);

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

sq2 = sqrt(2);

% For each 8x8 block...:
for i = 1 : NR
    for j = 1 : NC
        % submatrix for the corresponding 8x8 block
        subm = double(image( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ));
        
        if ( method == 0 )
            % built in DCT2:
            T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = dct2(subm);
            
        elseif ( method == 1 )
            % own implementation of DCT2
            
            B = zeros(N, N);
            
            % Should this be done? It is mentioned in:
            % https://en.wikipedia.org/wiki/JPEG#Discrete_cosine_transform
            %subm = subm - 128;
 
            % Calculate B(u,v) as described in the lecture 4 (week 2)
            for u = 1 : N
                for v = 1 : N
                    B(u, v) = 0;
            
                    for x = 1 : N
                        for y = 1 : N
                            B(u, v) = B(u, v) + subm(x, y) * c(x, u) * c(y, v);
                        end  % for y
                    end  % for x
                end  % for v
            end  % for u
            
            % Normalization of B:
            % All B's values are multiplied by 2/N,
            % then all elements of B's first column and first row
            % are additionally divided by sqrt(2):
            B = 2 * B / N;
            B(:, 1) = B(:, 1) / sq2;
            B(1, :) = B(1, :) / sq2;
            
            % Finally copy B into the corresponding region of T:
            T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = B;
            
        elseif ( method == 2 )
            % built in FFT
            T( (1+N*(i-1)) : (N*i), (1+N*(j-1)) : (N*j) ) = fft2(subm);
            
        else
            error('Invalid method');
        end  % if method

    end  % for j
end  % for i



end
