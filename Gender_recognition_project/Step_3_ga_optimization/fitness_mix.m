% This function will take a row vector W (contains four weights) as
% parameter, and returns the average error (of 5 different experiments) as
% fitness value for the Genetic algorithm.

function err = fitness_mix(W) % W is the weight vector
    
    % Load scores
    load('score.mat');

    % For 5 random experiments
    no_of_iter = 5; 
    
    % Number of test and training (M and F) 
    no_M_train = 80; %out of 113 (70%)
    no_F_train = 43; %out of 60 (70%)
    no_M_test = 113 - no_M_train;
    no_F_test =  60 - no_F_train;
    total_test = no_F_test + no_M_test;

    % Initializations
    TP = 0; % True positive
    TN = 0; % true negative
    FP = 0; % False positive
    FN = 0; % False negative

    for iter = 1 : 1 : no_of_iter % for all five experiments
        
        % Data selection according to experiment number (iter)
        st = ((iter-1)*total_test)+1;
        en = ((iter-1)*total_test)+50;
        P_list = score(st:en,:); % Total test data

        M_count = 0;
        F_count = 0;

        %%% score = [SVM_score, KNN_score, TREE_score, LASSO_score];
        combine_P = (P_list(:,1).*W(1) + P_list(:,2).*W(2) + P_list(:,3).*W(3) + P_list(:,4).*W(4))/sum(W); % Combined score (weighted average)

        % Calculate Threshold value
        pdM = fitdist(combine_P(1 : no_M_test,1),'Normal'); % Male dist
        pdF = fitdist(combine_P(no_M_test+1 : total_test,1),'Normal'); % Female dist
        P_thres = (pdM.mu + pdF.mu)/2;

        % Counting male predictions
        for i = 1 : no_M_test
            if combine_P(i) > P_thres
                M_count = M_count + 1;
            end
        end

        % Counting female predictions
        for i = no_M_test+1 : total_test
            if combine_P(i) <= P_thres
                F_count = F_count + 1;
            end
        end
        
        % Calculating Cumulative TP,TN,FN and FP
        TP = TP + M_count;
        FN = FN + (33-M_count);
        TN = TN + F_count;
        FP = FP + (17-F_count);
    end

    % Average error
    err = 1 - ((TP + TN)/(TP + TN + FN + FP));
end

