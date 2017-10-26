function disa_models(bin_ch)
% --------------------------------------------------------------------------
% Generate models (Fold 1 and Fold 2) for Discriminant analysis using 
% selected features. Parameter "bin_ch" is the binary chromosome of the best 
% individual for Discriminant analysis.
% --------------------------------------------------------------------------

    fs = find(bin_ch == true); % Select only the 1's location or index.
    load LP_1x.mat % All simple HOG features (length 360) of all 540 LP images (size 1x). 
    load nonLP_1x.mat % All simple HOG features (length 360) of all 1820 Non-LP images (size 1x).

    partition = 2;                           % Number of partitions (K).

    LP_test_co = floor(540/partition);       % Number of test samples (LP).
    nonLP_test_co = floor(1820/partition);   % Number of test samples (Non-LP).
    LP_train_co = 540 - LP_test_co;          % Number of train samples (LP).
    nonLP_train_co = 1820 - nonLP_test_co;   % Number of train samples (Non-LP).

    gamma = 0.08; % Value of gamma (for DISA classifier).
    
    LP1 = [LP1x(1:540,:), ones(540,1)];             % LP means 1.
    nonLP1 = [nonLP1x(1:1820,:), zeros(1820,1)];    % non-LP means 0.

    for k = 1:1:partition % Using K fold cross validation (K = Partition).
        % Making Training data.
        % Input features.
        X_train = LP1(1:LP_train_co,fs);
        X_train = [X_train; nonLP1(1:nonLP_train_co,fs)];
    
        % Output labels.
        Y_train = LP1(1:LP_train_co,361);
        Y_train = [Y_train; nonLP1(1:nonLP_train_co,361)];
    
        % Use circular shift for k-Fold cross validation.
        LP1 = circshift(LP1,LP_test_co);
        nonLP1 = circshift(nonLP1,nonLP_test_co);
    
        % DISA training. 
        model = ClassificationDiscriminant.fit(X_train, Y_train, 'gamma',gamma);
        
        % Saving models in the current directory.
        if(k == 1)
            my_disa1 = model;
            save disa1.mat my_disa1
        end
        if(k == 2)
            my_disa2 = model;
            save disa2.mat my_disa2
        end
    end
end
