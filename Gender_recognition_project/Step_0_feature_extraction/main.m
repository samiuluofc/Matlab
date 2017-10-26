% This program will read images and extract global perceptual features.
% Features will be saved as mat files (seperately for male and female). 

clear;
tic()

% Allocating zero matrix for data memory
F = zeros(12000,57); % 60 Females, 200 images per person, 57 dimensional data  
M = zeros(22600,57); % 113 Males, 200 images per person, 57 dimensional data

% Read 200 images from each male and extract visual features from the images  
for i = 1 : 113 % number of males
    for j = 1 : 200 % number of images per male
        str = strcat('Male user: ',int2str(i),' Image :', int2str(j));
        disp(str);
        
        str = strcat('G:\SAMIUL\BSc_MSc\MSC(Calgary)\Thesis\Datasets\Gender_flickr(SAMIUL)\Male\user(',int2str(i),')\img(',int2str(j),').jpg');
        img = imread(str);
        
        s = size(size(img));
        if s(1,2) == 2 % Testing whether an image is grayscale or not
            msg = strcat('User : ',int2str(i),', img : ',int2str(j),' is a grayscale image');
        else
            M((200*(i-1)+j),:) = feature_set1(img); % Returns extracted features. 
        end           
    end
end

% Save the extracted features for males
save M_113.mat M

% Read 200 images from each female and extract visual features from the images  
for i = 1 : 60 % number of female
    for j = 1 : 200 % number of images per female
        str = strcat('Female user: ',int2str(i),' Image :', int2str(j));
        disp(str);
        
        str = strcat('G:\SAMIUL\BSc_MSc\MSC(Calgary)\Thesis\Datasets\Gender_flickr(SAMIUL)\Female\user(',int2str(i),')\img(',int2str(j),').jpg');
        img = imread(str);
        
        s = size(size(img));
        if s(1,2) == 2 % Testing whether an image is grayscale or not
            msg = strcat('User : ',int2str(i),', img : ',int2str(j),' is a grayscale image');
        else
            F((200*(i-1)+j),:) = feature_set1(img); % Returns extracted features.
        end           
    end
end

% Save the extracted features for females
save F_60.mat F

toc()