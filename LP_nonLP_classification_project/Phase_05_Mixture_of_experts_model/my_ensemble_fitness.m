function err = my_ensemble_fitness(w, S)
% -------------------------------------------------------------------------
% This is the fitness function for the Mixture of experts model.
% "w" is the chromosome contains 04 weights (real numbers). 
% "w" controls the influence of each classifier.
% 
% w(1) is the weight for DTree,
% w(2) is the weight for KNN,
% w(3) is the weight for DISA, and
% w(4) is the weight for SVM.
% -------------------------------------------------------------------------
% Through S, we are selecting size (image resolution) of images 
% for testing. S can be '1' (original size), '2' (double size), 
% and 'h' (half size of original).
% -------------------------------------------------------------------------
% It returns classification error (in percentage) as a fitness 
% measure of an individual.
% -------------------------------------------------------------------------

    load chromosome.mat % Selected features for all classifiers.
   
    % Selecting feature matrix based on S.
    if S == 'h' % Half of the original size image (hx).
        load LP_hx.mat      % All simple HOG features (length 360) of all 540 LP images. 
        load nonLP_hx.mat   % All simple HOG features (length 360) of all 1820 Non-LP images.    
        LP1 = [LPhx(1:540,:), ones(540,1)];             % LP means 1.
        nonLP1 = [nonLPhx(1:1820,:), zeros(1820,1)];    % non-LP means 0.
    
    elseif S == '2' % Double of the original size image (2x).
        load LP_2x.mat      % All simple HOG features (length 360) of all 540 LP images. 
        load nonLP_2x.mat   % All simple HOG features (length 360) of all 1820 Non-LP images.    
        LP1 = [LP2x(1:540,:), ones(540,1)];             % LP means 1.
        nonLP1 = [nonLP2x(1:1820,:), zeros(1820,1)];    % non-LP means 0.
    
    else % Original size image (1x).
        load LP_1x.mat      % All simple HOG features (length 360) of all 540 LP images. 
        load nonLP_1x.mat   % All simple HOG features (length 360) of all 1820 Non-LP images.    
        LP1 = [LP1x(1:540,:), ones(540,1)];             % LP means 1.
        nonLP1 = [nonLP1x(1:1820,:), zeros(1820,1)];    % non-LP means 0. 
    end
    
    partition = 2;                           % Number of partitions (K).
    LP_test_co = floor(540/partition);       % Number of test samples (LP).
    nonLP_test_co = floor(1820/partition);   % Number of test samples (Non-LP).
    LP_train_co = 540 - LP_test_co;          % Number of train samples (LP).
    nonLP_train_co = 1820 - nonLP_test_co;   % Number of train samples (Non-LP).

    acc1 = 0;
    acc2 = 0;
    
    for k = 1:1:partition
        % Making Testing data (depending on selected features) for D-Tree. 
        X_test_tree = LP1(LP_train_co+1:540,logical(chro_tree));
        X_test_tree = [X_test_tree; nonLP1(nonLP_train_co+1:1820,logical(chro_tree))];
        
        % Making Testing data (depending on selected features) for KNN.
        X_test_knn = LP1(LP_train_co+1:540,logical(chro_knn));
        X_test_knn = [X_test_knn; nonLP1(nonLP_train_co+1:1820,logical(chro_knn))];
        
        % Making Testing data (depending on selected features) for DISA.
        X_test_disa = LP1(LP_train_co+1:540,logical(chro_disa));
        X_test_disa = [X_test_disa; nonLP1(nonLP_train_co+1:1820,logical(chro_disa))];
        
        % Making Testing data (depending on selected features) for SVM.
        X_test_svm = LP1(LP_train_co+1:540,logical(chro_svm));
        X_test_svm = [X_test_svm; nonLP1(nonLP_train_co+1:1820,logical(chro_svm))];
        
        % Loading target models.
        if(k == 1) % When fold 01 is considered.
            load tree1.mat; cur_tree = my_tree1;
            load disa1.mat; cur_disa = my_disa1;
            load knn1.mat; cur_knn = my_knn1;
            load svm1.mat; cur_svm = my_svm1;
        end
        if(k == 2) % When fold 02 is considered.
            load tree2.mat; cur_tree = my_tree2;
            load disa2.mat; cur_disa = my_disa2;
            load knn2.mat; cur_knn = my_knn2;
            load svm2.mat; cur_svm = my_svm2;
        end
        
        % Predicted probability by each classifier.
        [~,prob_tree] = predict(cur_tree, X_test_tree);
        [~,prob_knn]  = predict(cur_knn, X_test_knn);
        [~,prob_disa] = predict(cur_disa, X_test_disa); 
        [~,prob_svm]  = my_svmclassify(cur_svm, X_test_svm);       
        
        % Mixture of experts: Weighted combination of prediction.
        P = ((prob_tree(:,2) .* w(1)) + (prob_knn(:,2) .* w(2)) + (prob_disa(:,2) .* w(3)) + (prob_svm .* w(4)))./sum(w);
        
        % Final decision based on weighted probability.
        bin_LP    = P(1:LP_test_co) > 0.5; % License plate decisions.
        bin_nonLP = P(LP_test_co+1:LP_test_co+nonLP_test_co) <= 0.5; % Non license plate decisions.
        
        % Accuracy calculation.
        acc1 = acc1 + ((sum(bin_LP)./LP_test_co).*100); 
        acc2 = acc2 + ((sum(bin_nonLP)./nonLP_test_co).*100);
        
        % Shifting samples to get the next fold.
        LP1 = circshift(LP1,LP_test_co);
        nonLP1 = circshift(nonLP1,nonLP_test_co);
    end

    % Average accuracy of 2 fold cross-validation.
    LP_detection_accuracy = acc1./partition;
    nonLP_detection_accuracy = acc2./partition;
    overall_accuracy = (acc1+acc2)./(2*partition);
    
    % Misclassification error in percentage.
    err = 100 - overall_accuracy;  
end



