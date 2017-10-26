% Training and testing (cross validation accuracy)

clear;
tic();
load('random_split.mat');   % Contains 10 Splitting information (or 10 different experiments)
load('data_200users.mat');  % provides input matrix (Global perceptual and content)
load('HOG_win_3_bin_36.mat')% provides H matrix (HOG features)
load('local_200_Z.mat');    % provides Z matrix (Local perceptual features)

number_of_users = 200;
H(find(isnan(H))) = 0; % Replacing NaN value with zero

feature = zscore([input(:,1:87),Z,H]); % all features normalized into zero mean and unit standard deviation 

no_of_com = 700 % number of principle components
T = 0.01; % 99% variance will be retained in the transformed dataset
[U,~,~] = my_pca(feature,T);
feature = zscore(feature * U(:,1:no_of_com));

rank_cv = zeros(10,number_of_users); % Total 10 random splitting, 200 ranks

for ex = 1 : 1 : 10 % Total 10 random splitting (or 10 experiments)
    ex
    st = (ex-1)*100;
    train_index = split_index(st+1:st+100,1);
    test_index = setdiff((1:200)', train_index);

    W = zeros(no_of_com,number_of_users);    % All features
    
    all_Ntr = [];
    all_Nte = [];

    for user = 1:1:number_of_users
        index1 = train_index + ((user-1)*200);
        all_Ntr = [all_Ntr; feature(index1,:)];
        index2 = test_index + ((user-1)*200);
        all_Nte = [all_Nte; feature(index2,:)];
    end
 
    % Training
    for user = 1 : 1: number_of_users
        %user
        st = ((user-1)*100);
        Y = ones(number_of_users * 100,1) .* -1;
        Y(st+1:st+100,1) = 1;
        [B fitinfo] = lasso(all_Ntr,Y,'Standardize',false,'Lambda',0.0001);
        W(:,user) = B(:,1);
    end

    % Testing with cross validation
    % 200 users (200 rows and 200 columns)
    % Each row (each user testing) contain the rank list 1:200 
    
    % Calculating testing accuracy
    res = zeros(number_of_users,number_of_users);

    for user = 1:1:number_of_users
        st = ((user-1)*100);
        S = all_Nte(st+1:st+100,:) * W;
        sum_score = sum(S,1)./100;
        [r,res_I] = sort(sum_score,'descend');
        res(user,:) = res_I;
    end

    for r = 1:1:number_of_users % Changing the rank
        count = 0;
        for user = 1 : 1 : number_of_users
            ind = find(res(user,1:r) == user);
            if(~isempty(ind))
                count = count + 1;
            end
        end
        rank_cv(ex,r) = (count/number_of_users)*100;
    end
    
    %[rank_cv(ex,1) rank_cv(ex,5) rank_cv(ex,10)] % Provides Rank 1, 5 and 10 identification rates
end

save rank_cv.mat rank_cv

toc()