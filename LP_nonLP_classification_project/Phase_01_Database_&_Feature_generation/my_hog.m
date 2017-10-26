function HOG_hist = my_hog(img)
% -------------------------------------------------------------------------
% The histogram of oriented gradients (HOG) is an image descriptor used in
% computer vision and image processing for the purpose of object detection 
% [1]. This function will take a grayscale image as input parameter, and 
% return the HOG descriptor (1 by 360 matrix) of that image.
% -------------------------------------------------------------------------
% This implementation is the simplest version of the original HOG. 
% I consider the window-size fixed to 1 by 1 (that means a single pixel).
% -------------------------------------------------------------------------
% Reference:
% [1] https://en.wikipedia.org/wiki/Histogram_of_oriented_gradients.
% -------------------------------------------------------------------------

    img = double(img);               % Convert into double type. 
    x_grad = imfilter(img,[-1,0,1]); % Gradient in x direction for all pixels.
    y_grad = imfilter(img,[1;0;-1]); % Gradient in y direction for all pixels.
    
    ang = atan2(y_grad,x_grad);                      % Angle image in radian.
    mag = sqrt(((y_grad.*y_grad)+(x_grad.*x_grad))); % Magnitude image.
    
    % Initialization
    ang = ang(:);               % Convert it into a vector.   
    mag = mag(:);               % Convert it into a vector.
    len_of_ang = size(ang,1);   % Linear length of angle image.
    step = 2*pi/360;            % Step size is 1 degree.
    HOG_hist = zeros(1,360);    % 360 bins in the HOG.
    
    % Creating the histogram bins of magnitude for each angle (from -179 deg to 180 deg). 
    bin = 1;
    for cur_ang = -pi+step : step : pi       
        for i = 1 : 1 : len_of_ang       
           if ang(i) < cur_ang
                ang(i) = 2*pi; % Putting a large value or infinity.
                HOG_hist(bin) = HOG_hist(bin) + mag(i);
           end        
        end    
        bin = bin + 1;
    end
    
    HOG_hist = HOG_hist / norm(HOG_hist); % Normalized (L2-norm) bin.
end