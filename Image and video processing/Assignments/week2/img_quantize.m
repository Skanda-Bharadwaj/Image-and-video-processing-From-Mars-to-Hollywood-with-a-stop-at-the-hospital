function [ Q ] = img_quantize( tf, method, threshold )
%IMG_QUANTIZE Quantizes the image's transform
% 
% Input:
%   tf     - a matrix of transform's coefficients
%   method - quantization method (0:use the quantization matrix, 
%            1: quantize by 'threshold', 2: preserve 8 largest coefficients)
%   threshold - threshold for the method 1, otherwise ignored
%
% Return:
%   Q - matrix of quantized coefficients
%
% An error is reported if 'method' or 'threshold' is invalid 

% size of a block (NxN)
N = 8;

% image's dimension
[rows, cols] = size(tf);

% Number of 8x8 blocks
NR = floor( rows / N );
NC = floor( cols / N );

% Preallocation of T
Q = zeros(NR * N, NC * N);

% quantization matrix:
Qm = [ 16, 11, 10, 16, 24, 40, 51, 61; ...
       12, 12, 14, 19, 26, 58, 60, 55; ...
       14, 13, 16, 24, 40, 57, 69, 56; ...
       14, 17, 22, 29, 51, 87, 80, 62; ...
       18, 22, 37, 56, 68, 109, 103, 77; ...
       24, 35, 55, 64, 81, 104, 113, 92; ...
       49, 64, 78, 87, 103, 121, 120, 101; ...
       72, 92, 95, 98, 112, 100, 103, 99 ];
% another possible quantization matrix
% Qm = [ 52, 55, 61, 66, 70, 61, 64, 73; ...
%        63, 59, 66, 90, 109, 85, 69, 72; ...
%        62, 59, 68, 113, 144, 104, 66, 73; ...
%        63, 58, 71, 122, 154, 106, 70, 69; ...
%        67, 61, 68, 104, 126, 88, 58, 70; ...
%        79, 65, 60, 70, 77, 63, 58, 75; ...
%        85, 71, 64, 59, 55, 61, 65, 83; ...
%        87, 79, 69, 68, 65, 76, 78, 94 ];
   

for r = 1 : NR
    for c = 1 : NC
        % submatrix for the corresponding 8x8 block
        subm = double(tf( (1+N*(r-1)) : (N*r), (1+N*(c-1)) : (N*c) ));
        
        if ( method == 0)
            % use the quantization matrix Qm:
            Q( (1+N*(r-1)) : (N*r), (1+N*(c-1)) : (N*c) )  = round( subm ./ Qm ) .* Qm;
            
        elseif ( method == 1)
            % Quantize by threshold:
            
            % Check 'threshold' first: it must be a positive integer
            if ( threshold<1 | floor(threshold)~=threshold )
                error('Invalid theshold');
            end  % if
            
            Q( (1+N*(r-1)) : (N*r), (1+N*(c-1)) : (N*c) ) = round(subm / threshold) * threshold; 
            
        elseif (method == 2 )
            % Preserve 8 largest coefficients (by absolute value)
            rs = sort(reshape(abs(subm), N*N, 1), 'descend');
            th = rs(N);
            Q( (1+N*(r-1)) : (N*r), (1+N*(c-1)) : (N*c) ) = round(subm .* (abs(subm)>=th));
            
        else
            error('Invalid method');
        end  % if method
    end  % for c
end  % for r 

end
