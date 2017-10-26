% -------------------------------------------------------------------------
% Generate HOG (Histogram Oriented Gradient) feature matrices for both LPs
% and Non-LPs of original, double, and half size images. After running this
% script, you will get following 06 mat files.
%
%     LPs     : LP_1x.mat, LP_2x.mat, LP_hx.mat
%     Non-LPs : nonLP_1x.mat, nonLP_2x.mat, nonLP_hx.mat
% -------------------------------------------------------------------------
% Execution time of this script is high (around 09 minutes). Because it
% generates HOG descriptor for 3 x (540 + 1820) LP and Non-LP images.
% -------------------------------------------------------------------------

clear   % Clear the program memory.
tic()   % Time count starts.

% Generating feature matrices for LPs......................................

% Initilization (Creating empty matrices).
LP1x = [];      % For original (1x) spatial resolution.
LP2x = [];      % For double (2x) of the original spatial resolution.
LPhx = [];      % For half (hx) of the original spatial resolution.

for i = 1:1:540 % Total number of LPs.
    img = imread(strcat('CLP_Database/LP/plate(',int2str(i),').jpg'));
    
    % Convert to grayscale image from RGB
    img = rgb2gray(img);
    
    % Bicubic interpolation for resizing LPs.
    img1x = imresize(img,1,'bicubic');  
    img2x = imresize(img,2,'bicubic');
    imghx = imresize(img,0.5,'bicubic');
    
    % Calculating HOG features for different sizes of LPs.
    H = my_hog(img1x); % Applying HOG function.
    LP1x = [LP1x; H];
    
    H = my_hog(img2x); 
    LP2x = [LP2x; H];
        
    H = my_hog(imghx);
    LPhx = [LPhx; H];
end

% Saving feature matrices
save LP_1x.mat LP1x
save LP_2x.mat LP2x
save LP_hx.mat LPhx


% Generating feature matrices for Non-LPs..................................

% Initilization (Creating empty matrices).
nonLP1x = [];      % For original (1x) spatial resolution.
nonLP2x = [];      % For double (2x) of the original spatial resolution.
nonLPhx = [];      % For half (hx) of the original spatial resolution.

for i = 1:1:1820 % Total number of Non-LPs.
    img = imread(strcat('CLP_Database/Non-LP/non(',int2str(i),').jpg'));
    
    % Convert to grayscale image from RGB.
    img = rgb2gray(img); 
    
    % Bicubic interpolation for resizing Non-LPs.
    img1x = imresize(img,1,'bicubic');  
    img2x = imresize(img,2,'bicubic');
    imghx = imresize(img,0.5,'bicubic');
    
    % Calculating HOG features for different sizes of Non-LPs.
    H = my_hog(img1x); % Applying HOG function.
    nonLP1x = [nonLP1x; H];
    %stem(H);
    H = my_hog(img2x);
    nonLP2x = [nonLP2x; H];
    
    H = my_hog(imghx);
    nonLPhx = [nonLPhx; H];
end

% Saving feature matrices
save nonLP_1x.mat nonLP1x
save nonLP_2x.mat nonLP2x
save nonLP_hx.mat nonLPhx

toc() % Time count ends.