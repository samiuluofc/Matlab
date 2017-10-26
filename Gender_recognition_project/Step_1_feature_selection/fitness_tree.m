% This function receives selected features for Decision Tree and returns average 
% gender prediction error of 5 different experiments. 

function err = fitness_tree(bin_chrom) 

% Load necessary Data
load('F_60.mat'); % Z score normalized data
load('M_113.mat');

% provide F_index_image and M_index_image matrix.
% These two matrix contains random indices of images. 
load('random_index.mat'); 

% Select the features based on binary chromosome  
fs = find(bin_chrom); 

% Five random experiments
no_of_iter = 5; 

% Number of test and training (M and F) 
no_M_train = 80; % out of 113 (70%)
no_F_train = 43; % out of 60 (70%)

no_M_test = 113 - no_M_train;
no_F_test =  60 - no_F_train;

total_test = no_F_test + no_M_test;

% Initialization
total_avg = 0;
total_avg_M = 0;
total_avg_F = 0;
L = 29; % Number of minimum leaf for DTree

% For each experiment (random sampling), we conduct training and testing.
% Calculate average accuracy of 5 experiments.
for iter = 1 : 1 : no_of_iter
    
    % Selection of Training and testing data for males
    M_train = M(M_index_image(1:no_M_train * 200,iter),fs);
    M_test = M(M_index_image((no_M_train*200) + 1 : 113 * 200,iter),fs);

    % Selection of Training and testing data for females
    F_train = F(F_index_image(1:no_F_train * 200,iter),fs);
    F_test = F(F_index_image((no_F_train*200) + 1 : 60 * 200,iter),fs);

    X = [M_train; F_train]; % Total train data

    Y = [ones(no_M_train*200,1) ; ones(no_F_train*200,1) .* -1]; % Labels 
    X_test = [M_test; F_test]; % Total test data
  
    % Training with DTree
    model = ClassificationTree.fit(X, Y, 'MinLeaf',L);
    
    % Testing
    [result,~] = predict(model,X_test);
    
    % Calculate gender probability
    P_list = zeros(total_test,1); 
    for i = 1: total_test
       S = sum(result(((i-1)*200) + 1 : ((i-1)*200) + 200,1));
       P_list(i,1) = S/200;
    end

    M_count = 0;
    F_count = 0;

    % Calculate threshold value
    pdM = fitdist(P_list(1 : no_M_test,1),'Normal'); % Male dist
    pdF = fitdist(P_list(no_M_test+1 : total_test,1),'Normal'); % Female dist
    P_thres = (pdM.mu + pdF.mu)/2;

    % Counting male predictions
    for i = 1 : no_M_test
        if P_list(i) > P_thres
            M_count = M_count + 1;
        end
    end

    % Counting female predictions
    for i = no_M_test+1 : total_test
        if P_list(i) <= P_thres
            F_count = F_count + 1;
        end
    end

    % Calculating average accuracies
    M_acc = (M_count/no_M_test)*100;
    F_acc = (F_count/no_F_test)*100;
    avg_accu = (M_acc + F_acc)/2;
    
    total_avg = total_avg + avg_accu;
    total_avg_M = total_avg_M + M_acc;
    total_avg_F = total_avg_F + F_acc;
end

err = 100-(total_avg/no_of_iter); % Return total error in percentage
errM = 100-(total_avg_M/no_of_iter);
errF = 100-(total_avg_F/no_of_iter);