function [ level ] = img_otsu( img )
%IMG_OTSU Finds the grayscale image's global threshold, using the Otsu's
%         method. Similar to the built-in function 'graythresh'.
%
% Input:
%   img - a matrix of image's pixels
%
% Return:
%   level - non-normalized threshold (between 0 and 255)


% Nr. of intensities for 8-bit grayscale images:
N = 256;

% Normalized image's histogram (sum of all bins = 1)
% Note that p's elements represent probablities of pixel values
% between 0 (p(0)) and 255 (p(256).
p = imhist(img) / numel(img);

% The Otsu's method attempts divides the image into 2 classes and attempts
% to minimize the within class variance (replace all s's by sigmas in the
% expressions below):
% 
%   s_within(t)^2 = wB(t) * sB(t)^2 + wF(t) * sF(t)^2
%
% However, this method may be computationally expensive.
%
% It is possible to express the between class variance from the within class 
% variance:
%
%   s_between(t)^2 = s^2 - s_within(t)^2
%
% Since s^2 is constant, the procedure is equivalent to maximizing the
% s_between(t). It can be further expressed as:
%
%   s_between(t)^2 = wB(t) * wF(t) * [muB(t) - muF(t)]^2
%
% where wB(t), wF(t), muB(t) and muF(t) are defined as:
%
%             t
%           -----
%           \
%   wB(t) =  >    p(t)                                ( 1 )
%           /
%           -----
%            i=1
%
%             N
%           -----
%           \
%   wB(t) =  >    p(t)                                ( 2 )
%           /
%           -----
%           i=t+1
%
%                        t
%                      -----
%               1      \
%   muB(t) = ------- *  >   (i-1) * p(i)              ( 3 )
%             wB(t)    /
%                      -----
%                       i=1
%
%                        N
%                      -----
%               1      \
%   muF(t) = ------- *  >   (i-1) * p(i)              ( 4 )
%             wF(t)    /
%                      -----
%                      i=t+1
%
% It turns out that s_between(t) can be calculated efficiently.
%


% Initial values of 'level' and 's_between_max'
level = 0;
s_between_max = 0;

% Initial values of wB, wF, muB anf muF:
wB = 0;
muB = 0;
wF = 1;
muF =  ( 0 : (N-1) ) * p;

% For each probabity p(t)....
for t = 1 : N
    % As evident from the expressions (1) and (2) above, both w's can be 
    % easily expressed from their previous values.
    % Note that previous values of w's will also be required to update the
    % mu's.
    wBn = wB + p(t);
    wFn = wF - p(t);
    
    % From expressions (3) and (4) above it is not too difficult to obtain 
    % the formula to update both mu's from their previous values.
    % Previous values of both mu's are multiplied by previous values of 
    % their corresponding mu's, t*p(t+1) is added (or subtracted) to/from
    % the products and the total sum/difference is then divided by the new
    % value of the corresponding w:
    %
    %               muB(t) * wB(t) + (t) * p(t+1)
    %   muB(t+1) = -------------------------------        ( 5 )
    %                        wB(t+1)
    %
    %               muF(t) * wF(t) - (t) * p(t+1)
    %   muF(t+1) = -------------------------------        ( 6 )
    %                        wF(t+1)
    %
    
    % Apply the expressions (5) and (6).
    % Note that we are actualy updating from t-1 to t.
    % Also prevent possible division by zero.
    if (wBn ~= 0 )
        muB = (muB*wB + (t-1)*p(t)) / wBn;
    else
        muB = 0;
    end  % if
    
    if (wFn ~= 0 )
        muF = (muF*wF - (t-1)*p(t)) / wFn;
    else
        muF = 0;
    end  % if
    
    % Previous values of wB and WF are not neede anymore, hence they can be
    % updated:
    wB = wBn;
    wF = wFn;
    
    % Between class variance for the current 't':
    s_between = wB * wF * (muB-muF)^2;
    
    % Update it if it is greater than the greatest between class variance
    % so far:
    if ( s_between > s_between_max )
        level = t-1;
        s_between_max = s_between;
    end  % if
    
end  % for t

end
