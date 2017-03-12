function [ bwimg ] = img_region_grow( img, seeds )
%IMG_REGION_GROW Segmentation of an image using the region growing method,
%                starting at the given seeds. This implementation selects
%                pixels with intensities close to the meen value of initial
%                seeds' intensities.
%
% Input:
%   img   - a matrix of image's pixels
%   seeds - coordinates (a 2xn matrix) of initial seed pixels
%
% Return:
%   bwimg - - a matrix (logical values) of the segmented image 
%
% An error is reported if dimension of 'seeds' is invalid


% Dimensions of the original image
[ rows, cols ] = size(img);

% Preallocation of the temporary matrix with states.
% The matrix contains 3-state values:
%    1 - the pixel has been classified as a foreground pixel
%   -1 - the pixel has been classified as a background pixel
%    0 - the pixel has not been examined (yet)
tempmat = int8(zeros(rows, cols));

% Dimesions of seeds
[ sr, sc ] = size(seeds);

% check if sr==2
if ( sr ~= 2 )
    error('Invalid dimension of ''seeds''');
end  % if

% Intensities of seed pixels:
vals = zeros(1, sc);
for i = 1 : sc
    x = seeds(1, sc);
    y = seeds(2, sc);
    
    vals(i) = img(x, y);
    
    % Seed pixels are already classified as foreground:
    tempmat(x, y) = 1;
end  % for i

% The criteria for classification of pixels.
% All classified pixels' neighbours will be examined if their intensities
% iare reasonably close to the seeds' mean intensity
%
% The criteria may be reimplemented if necessary.

% Obtain mean and standard deviation of seed pixels' intensities
mu = mean(vals);
sigma = std(vals);

% Implement the criteria:
Z = 2;
dv = max(50, Z*sigma);
thmin = max(0, mu-dv);
thmax = min(255, mu+dv);

% Previously classified pixels
newp = seeds;
modified = true;

% Repeat the loop until no additional pixels have been classified as
% foreground:
while ( modified==true )
   
    % reset the control variable (will be set to 'true' if additional pixels 
    % have been classified)
    modified = false;
    
    % Previously classified pixels:
    pnewp = newp;
    newp = [];
    
    [~, pnpcols] = size(pnewp);
    
    % For each previously classified pixel...
    for i = 1 : pnpcols
        x = pnewp(1, i);
        y = pnewp(2, i);
        
        % ... check all of its neighbours (within the image's boundaries)
        for xn = max(1, x-1) : min(rows, x+1)
            for yn = max(1, y-1) : min(cols, y+1)
                
                % Skip the neghbouring pixel if it has been examined before
                if ( tempmat(xn, yn) ~= 0 )
                    break;  % for yn
                end  % if
                
                % Finally check the neghbouring pixel if it satisfies the
                % criteria
                PIX = img(xn, yn);
                if ( PIX >= thmin && PIX <= thmax )
                    % If it does, mark it accordingly in 'tempmat'...
                    tempmat(xn, yn) = 1;
                    % its neighbours will be checked in the next iteration
                    % of the while loop...
                    newp = [newp, [xn; yn] ];
                    % ... and request at least one more iteration.
                    modified = true;
                else
                    % If the pixel does not match the criteria,
                    % just mark it in 'tempmat'
                    tempmat(xn, yn) = -1;
                end  % if
                
            end  % for yn
        end  % for xn
        
    end  % for i
    
end  % while

% Finally enable classified pixels in the return matrix of logical values
bwimg = boolean(tempmat == 1);

end
