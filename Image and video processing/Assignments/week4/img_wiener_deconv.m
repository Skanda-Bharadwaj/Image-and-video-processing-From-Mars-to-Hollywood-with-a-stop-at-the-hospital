function [ fimg ] = img_wiener_deconv( img, H, K )
%IMG_WIENER_DECONV Performs Wiener deconvolution on the degraded image
%
% Input:
%   img - a matrix of (degraded) image's pixels
%   H   - degradation filter
%   K   - a constant that replaces power spectral density of signal and noise
%
% Return:
%   fimg - a matrix of filtered image's pixels

% Dimension of H
[ hrows, hcols ] = size(H);

% Dimensions of img
[ rows, cols ] = size(img);

% sanity check
if ( hrows>rows || hcols>cols )
    error('H is too large!');
end  % if

% Preallocate fimg
fimg = double( img );

% Preallocate ht (must have the same dimensions as img)
ht = zeros(rows, cols);

% Plug 'H' into the upper left corner of ht
ht( 1:hrows, 1:hcols ) = H;

fht = fft2(ht);
G = fft2(fimg);

%
%                *
%               H (u,v)
%  F(u,v) = ---------------- * G(u,v)
%            |H(u,v)|^2 + K
%
%

for u = 1 : rows
    for v = 1 : cols
        Fi(u, v) = conj(fht(u, v)) * G(u, v) / (abs(fht(u, v))^2 + K);
    end  % for v
end  % for u

% Obtain inverse FFT on Fi and convert their elements' real parts to uint8
fimg = uint8( real( ifft2(Fi) ) );

end
