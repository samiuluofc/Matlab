function accuracy = mixture_fitness(w, S)
% -------------------------------------------------------------------------
% It tests CLP data based on weight vector (w) and size of the image (S).
% It takes w and S as parameter.
%
%   w(1) is the weight for DTree,
%   w(2) is the weight for KNN,
%   w(3) is the weight for DISA, and
%   w(4) is the weight for SVM.
% 
% Through S, we are selecting size (image resolution) of 
% images for testing. S can be '1' (original size), '2' 
% (double size), and 'h' (half of original size).
% ------------------------------------------------------------------------- 
% It returns classification accuracy (in percentage).
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
     
    % Making Testing data (depending on selected features) for D-Tree.
    X_test_tree = LP1(1:540,logical(chro_tree));
    X_test_tree = [X_test_tree; nonLP1(1:1820,logical(chro_tree))];
    
    % Making Testing data (depending on selected features) for KNN.
    X_test_knn = LP1(1:540,logical(chro_knn));
    X_test_knn = [X_test_knn; nonLP1(1:1820,logical(chro_knn))];
    
    % Making Testing data (depending on selected features) for DISA.
    X_test_disa = LP1(1:540,logical(chro_disa));
    X_test_disa = [X_test_disa; nonLP1(1:1820,logical(chro_disa))];
    
    % Making Testing data (depending on selected features) for SVM.
    X_test_svm = LP1(1:540,logical(chro_svm));
    X_test_svm = [X_test_svm; nonLP1(1:1820,logical(chro_svm))];
    
    % Loading trained models
    load tree.mat; cur_tree = my_tree;
    load disa.mat; cur_disa = my_disa;
    load knn.mat; cur_knn = my_knn;
    load svm.mat; cur_svm = my_svm;
        
    % Predicted probability by each classifier.
    [~,prob_tree] = predict(cur_tree, X_test_tree);
    [~,prob_knn]  = predict(cur_knn, X_test_knn);
    [~,prob_disa] = predict(cur_disa, X_test_disa);
    [~,prob_svm]  = my_svmclassify(cur_svm, X_test_svm);
    
    % Mixture of experts: Weighted combination of prediction.
    P = ((prob_tree(:,2) .* w(1)) + (prob_knn(:,2) .* w(2)) + (prob_disa(:,2) .* w(3)) + (prob_svm .* w(4)))./sum(w);
    
    % Final decision based on weighted probability.
    bin_LP    = P(1:540) > 0.5; % License plate decisions.
    bin_nonLP = P(541:2360) <= 0.5; % Non license plate decisions.
    
    % Accuracy calculation.
    acc1 = ((sum(bin_LP)./540).*100);
    acc2 = ((sum(bin_nonLP)./1820).*100);
    
    % Average acuuracy.
    accuracy = (acc1+acc2)./2;
end



