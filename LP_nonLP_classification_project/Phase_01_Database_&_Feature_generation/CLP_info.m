% -------------------------------------------------------------------------
% This script will provide you some statistical information about the    
% (Candidate License Plate) CLP database. The CLP database contains 540
% License Plate (LP) images and 1820 Non License Plate (Non-LP) images.
% All these images (LP and Non-LP) are generated using the Automatic
% License Plate Detection (ALPD) algorithm and the vehicle image database
% (contains 565 images) from the article [1]. Resolution of each vehicle
% image is 640 x 480.
% -------------------------------------------------------------------------
% Execution time of this script is around 6 seconds. It generates a text
% file "CLP_info_output.txt" that contains the outputs.
% -------------------------------------------------------------------------
% Reference:
% [1] Samiul Azam, Md Monirul Islam, "Automatic License Plate Detection
% in Hazardous Condition," Journal of Visual Communication and Image
% Representation, ELSEVIER, Vol. 36, April 2016, Pages 172-186,
% ISSN 1047-3203, http://dx.doi.org/10.1016/j.jvcir.2016.01.015.
% -------------------------------------------------------------------------

clear       % Clear the program memory.
tic()       % Time count starts.

% Open a text file in write mode.
file_write = fopen('CLP_info_output.txt','w'); 

% For LP images............................................................

total_h = 0;    % For calculating average height of the LPs.
total_w = 0;    % For calculating average width of the LPs.
total_res = 0;  % For calculating sum of all LPs spatial resolution.

for i = 1 : 1 : 540 % Total 540 LPs.
    img = imread(strcat('CLP_Database/LP/plate(',int2str(i),').jpg'));
    
    % Convert to grayscale image from RGB.
    img = rgb2gray(img); 
    
    % Calculating some basic image properties, such as resolution, height,
    % width, total resolution, total width, total height.
    [h w] = size(img); % Height and Width.
    total_res = total_res + (h*w);    
    total_h = total_h + h;
    total_w = total_w + w;
end

average_height_LP = total_h./540;
average_width_LP = total_w./540;

% Percentage of LP area over full vehicle images.
LP_per = (total_res./(640*480*565))*100; %

fprintf(file_write,'LP: (Total 540)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\n');
fprintf(file_write,'Percentage of LP area over the full images: %.2f\r\n',LP_per);
fprintf(file_write,'Average height (in pixels) of LPs : %.0f\r\n',average_height_LP);
fprintf(file_write,'Average width (in pixels) of LPs  : %.0f\r\n\r\n',average_width_LP);


% For Non-LP images........................................................

total_h = 0;    % For calculating average height of Non-LPs.
total_w = 0;    % For calculating average width of Non-LPs.
total_res = 0;  % For calculating sum of all non-LPs spatial resolution.

for i = 1:1:1820 % Total 1820 Non-LPs.
    img = imread(strcat('CLP_Database/Non-LP/non(',int2str(i),').jpg'));
    
    % Convert to grayscale image from RGB.
    img = rgb2gray(img);
    
    % Calculating some basic image properties, such as resolution, height,
    % width, total resolution, total width, total height.
    [h w] = size(img); % Height and Width. 
    total_res = total_res + (h*w);    
    total_h = total_h + h;
    total_w = total_w + w;
end

average_height_nonLP = total_h./1823;
average_width_nonLP = total_w./1823;

% Percentage of Non-LP area over full vehicle images.
nonLP_per = (total_res./(640*480*565))*100;

fprintf(file_write,'Non-LP: (Total 1820)>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\n');
fprintf(file_write,'Percentage of Non-LP area over the full images: %.2f\r\n',nonLP_per);
fprintf(file_write,'Average height (in pixels) of Non-LPs : %.0f\r\n',average_height_nonLP);
fprintf(file_write,'Average width (in pixels) of Non-LPs  : %.0f\r\n',average_width_nonLP);

fclose(file_write); % File closing.
toc()               % Time counting ends.