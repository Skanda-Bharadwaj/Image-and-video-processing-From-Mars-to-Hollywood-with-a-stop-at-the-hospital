function [ H ] = err_entropy( eh )
%ERR_ENTROPY Calculates the entropy of prediction errors.
%
% Input:
%   eh - a two row matrix, the 1st row is ignored, the 2nd row contains
%        the number of occurrences (must be a positive integer) for each 
%        error value
%
% Return:
%   H - entropy of prediction errors

% Sum of all occurrences...
s = sum(eh(2, :));
% ... to obtain relative frequencies:
p = double(eh(2, :)) / double(s);

% A logarithm will be applied on relative frequencies. As a logarithm of 0
% is not defined, all occurrences of 0 in 'p' will be replaced by 1
% (additionally this will evaluate such logarithms to 0):
l = p;
l(l==0) = 1;

% Finally the entropy can be obtained as:
%
%           N
%         -----
%         \
%   H = -  >  p(i) * log2(p(i))
%         /
%         -----
%          i=1

H = -sum(p .* log2(l));

end
