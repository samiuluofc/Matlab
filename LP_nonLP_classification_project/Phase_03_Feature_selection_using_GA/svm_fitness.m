function err = svm_fitness(bin_ch)
% -------------------------------------------------------------------------
% This is the Fitness function for the feature selection of Support vector
% machine classifier using GA. Parameter "bin_ch" is the binary chromosome
% (1 means feature is selected, and 0 means not selected). 
% -------------------------------------------------------------------------
% It returns classification error (in percentage) as a fitness measure 
% of an individual.
% -------------------------------------------------------------------------
 

    
    fs = find(bin_ch == true); % Selects only the 1's location or index.
    load LP_1x.mat      % All simple HOG features (length 360) of all 540 LP images (1x size). 
    load nonLP_1x.mat   % All simple HOG features (length 360) of all 1820 Non-LP images (1x size).

    partition = 2;                           % Number of partitions (K).

    LP_test_co = floor(540/partition);       % Number of test samples (LP).
    nonLP_test_co = floor(1820/partition);   % Number of test samples (Non-LP).
    LP_train_co = 540 - LP_test_co;          % Number of train samples (LP).
    nonLP_train_co = 1820 - nonLP_test_co;   % Number of train samples (Non-LP).

    S = 5.6; % Value of Sigma (for SVM classifier).
    
    LP1 = [LP1x(1:540,:), ones(540,1)];             % LP means 1.
    nonLP1 = [nonLP1x(1:1820,:), zeros(1820,1)];    % non-LP means 0.

    acc1 = 0;
    acc2 = 0;

    for k = 1:1:partition % Using K fold cross validation (K = Partition).
        % Making training data.
        X_train = LP1(1:LP_train_co,fs);
        X_train = [X_train; nonLP1(1:nonLP_train_co,fs)];
    
        % Output labels.
        Y_train = LP1(1:LP_train_co,361);
        Y_train = [Y_train; nonLP1(1:nonLP_train_co,361)];
    
        % Making testing data.
        X_test = LP1(LP_train_co+1:540,fs);
        X_test = [X_test; nonLP1(nonLP_train_co+1:1820,fs)];
    
        % Use circular shift for k-Fold cross validation.
        LP1 = circshift(LP1,LP_test_co);
        nonLP1 = circshift(nonLP1,nonLP_test_co);
    
        % SVM classifier training.
        op = statset('MaxIter',30000);
        my_svm = svmtrain(X_train, Y_train,'Kernel_Function', 'rbf', 'rbf_sigma',S,'options',op);
        
        % SVM classifier testing.
        [result,~] = my_svmclassify(my_svm, X_test);
              
        % Accuracy of LP detection.
        res1 = (sum(result(1:LP_test_co))./LP_test_co).*100;
        % Accuracy of non-LP detection.
        res2 = ((nonLP_test_co-sum(result(LP_test_co+1:LP_test_co+nonLP_test_co)))./nonLP_test_co).*100;
        
        % Cumulative addition of each fold's accuracy. 
        acc1 = acc1 + res1;
        acc2 = acc2 + res2;   
    end
    
    % Accuracy and Error in percentage.
    overall_accuracy = (acc1+acc2)./(2*partition);
    err = 100 - overall_accuracy;
end
