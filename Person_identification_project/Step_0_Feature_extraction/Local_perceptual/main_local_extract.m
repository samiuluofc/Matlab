clear;
tic()

Z = zeros(40000, 513); % 57 x 9 = 513 (3 by 3 splitting of the images)
c = 1;

for i = 1 : 200 % number of users
    for j = 1 : 200 % number of images per person
        
        str = strcat('User: ',int2str(i),' Image :', int2str(j));
        disp(str);
        str = strcat('G:\SAMIUL\BSc_MSc\MSC(Calgary)\Thesis\Datasets\Faved_biometric_original\data\user(',int2str(i),')\img(',int2str(j),').jpg');
        img = imread(str);
        
        [h,w,~] = size(img);
        w_jump = floor(w/3);
        h_jump = floor(h/3);
        
        F = zeros(9,57);
        k = 1;
        for m = 0: w_jump : w-4 % columnwise
            for n = 0 : h_jump : h-4
                I = imcrop(img, [m+1 n+1 w_jump-1 h_jump-1]);       
                F(k,:) = feature_set1(I);
                k = k + 1;
            end
        end
        
        Z(c,:) = F(:)'; % Columnwise (That means one specific feature is in sequential order of 9 segments)
        c = c + 1;
    end
end


save local_200_Z.mat Z
toc()