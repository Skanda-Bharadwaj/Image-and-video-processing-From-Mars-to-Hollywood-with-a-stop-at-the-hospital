function [ inpv ] = median_inpaint( v, N )
%MEDIAN_INPAINT Performs inpainting of videos with medians of consecutive
%               frames
%
% Input:
%   v - video represented a s a 4d matrix (rows x columns x channels x frames)
%   N - number of frames before and after the current frame to calculate
%       the median
%
% Return:
%   inpv - a 4D matrix representing the inpainted video


% TODO
% The function would require an additional mask of pixels to be inpainted
% that would be passed as another input argument. Additionally the mask
% could be moved and/or resized w.r.t. time.


% Elements of size represent frames' height (rows), width (columns), nr. of
% channels and the number of frames
[ ~, ~, ~, Nf] = size(v);

% Preallocation of 'inpv'
inpv = v;

for i = 1 : Nf
    fmin = max(1, i-N);
    fmax = min(Nf, i+N);
    
    % Median of 2*N+1consecutive frames:
    inpv(:, :, :, i) = median(v(:, :, :, fmin:fmax), 4);
end  % for i

end
