clear;
tic()

%wins = 1; bins = 36; % 10 degree intervals, 1 x 1 blocks, feature size: 36
%wins = 1; bins = 18; % 20 degree intervals, 1 x 1 blocks, feature size: 18
%wins = 1; bins = 12; % 30 degree intervals, 1 x 1 blocks, feature size: 12

%wins = 2; bins = 36; % 10 degree intervals, 2 x 2 blocks, feature size: 144
%wins = 2; bins = 18; % 20 degree intervals, 2 x 2 blocks, feature size: 72
%wins = 2; bins = 12; % 30 degree intervals, 2 x 2 blocks, feature size: 48

wins = 3; bins = 36; % 10 degree intervals, 3 x 3 blocks, feature size: 324
%wins = 3; bins = 18; % 20 degree intervals, 3 x 3 blocks, feature size: 162
%wins = 3; bins = 12; % 30 degree intervals, 3 x 3 blocks, feature size: 108

%wins = 4; bins = 36; % 10 degree intervals, 4 x 4 blocks, feature size: 576
%wins = 4; bins = 18; % 20 degree intervals, 3 x 3 blocks, feature size: 288
%wins = 4; bins = 12; % 30 degree intervals, 3 x 3 blocks, feature size: 192


H = zeros(40000, wins .* wins .* bins);
c = 1;

for i = 1 : 200 % number of users
    i
    for j = 1 : 200 % number of images
        str = strcat('User: ',int2str(i),' Image :', int2str(j));
        
        % Pls change the path if you set the database into other directory
        str = strcat('C:\MSC(Calgary)\Thesis\Datasets\Faved_biometric_original\data\user(',int2str(i),')\img(',int2str(j),').jpg');
        img = rgb2gray(imread(str));
        [h, w] = size(img);
        chsize = floor(h/wins);
        cwsize = floor(w/wins);
        [H(c,:),~] = extractHOGFeatures(img,'CellSize',[chsize cwsize],'NumBins',bins, 'BlockSize',[1 1]);
        c = c + 1;
    end
end

save HOG_win_3_bin_36.mat H 

toc()