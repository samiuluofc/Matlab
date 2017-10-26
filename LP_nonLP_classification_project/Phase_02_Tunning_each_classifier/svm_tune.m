function svm_tune()
% -------------------------------------------------------------------------
% The purpose of the function is to find the BEST value of Sigma
% (sensitive parameter) for Support Vector Machine (SVM) classifier 
% (when the K fold cross validation accuracy is maximum). I consider 
% the Neighbor values within the range 5 to 15, and 2-fold cross 
% validation. 
% -------------------------------------------------------------------------
% It will generate the accuracy-vs-sigma graph, and also create an
% output textfile containing information about the peak accuracy.
% -------------------------------------------------------------------------

    load LP_1x.mat      % All simple HOG features (length 360, size 1x) of all 540 LP images. 
    load nonLP_1x.mat   % All simple HOG features (length 360, size 1x) of all 1820 Non-LP images.
    file_write = fopen('svm_output.txt','w'); % Open a text file in write mode.
    
    overall_accuracy = [];  % Empty list (to store each accuracy).
    sigma_seq = [];         % Empty list (to store each Sigma value).
    t = 0;                  % For calculating testing time. Initially 0.
    partition = 2;          % Number of partitions (K).

    LP_test_co = floor(540/partition);       % Number of test samples (LP).
    nonLP_test_co = floor(1820/partition);   % Number of test samples (Non-LP).
    LP_train_co = 540 - LP_test_co;          % Number of training samples (LP).
    nonLP_train_co = 1820 - nonLP_test_co;   % Number of training samples (Non-LP).

    for S = 5: 0.1: 15 % Sigma values from 5 to 15 increamented by 0.1
        % Initialization
        LP1 = [LP1x(1:540,:), ones(540,1)];             % LP means 1.
        nonLP1 = [nonLP1x(1:1820,:), zeros(1820,1)];    % Non-LP means 0.
        acc1 = 0;
        acc2 = 0;

        % Using K fold cross validation (K = Partition).
        for k = 1:1:partition
        
            % Making Training data.
            % Input features (all 360 features).
            X_train = LP1(1:LP_train_co,1:360);
            X_train = [X_train; nonLP1(1:nonLP_train_co,1:360)];
    
            % Output labels.
            Y_train = LP1(1:LP_train_co,361);
            Y_train = [Y_train; nonLP1(1:nonLP_train_co,361)];
    
            % Making Testing data.
            X_test = LP1(LP_train_co+1:540,1:360);
            X_test = [X_test; nonLP1(nonLP_train_co+1:1820,1:360)];
    
            % Use circular shift for k-Fold cross validation.
            LP1 = circshift(LP1,LP_test_co);
            nonLP1 = circshift(nonLP1,nonLP_test_co);
    
            % SVM classifier training.
            op = statset('MaxIter',30000);
            my_svm = svmtrain(X_train, Y_train,'Kernel_Function', 'rbf', 'rbf_sigma',S,'options',op);
        
            % SVM classifier testing.
            tic() % Time count (only testing) starts.
            [result,~] = my_svmclassify(my_svm, X_test);
            t = t + toc(); % Time count ends.
            
            % Accuracy of LP detection.
            res1 = (sum(result(1:LP_test_co))./LP_test_co).*100;
            % Accuracy of non-LP detection.
            res2 = ((nonLP_test_co-sum(result(LP_test_co+1:LP_test_co+nonLP_test_co)))./nonLP_test_co).*100;
        
            % Cumulative addition of each fold's accuracy. 
            acc1 = acc1 + res1;
            acc2 = acc2 + res2;   
        end
    
        % Accuracy Calculation.
        LP_detection_accuracy = acc1./partition;
        nonLP_detection_accuracy = acc2./partition; 
        overall_accuracy = [overall_accuracy; (acc1+acc2)./(2*partition), LP_detection_accuracy, nonLP_detection_accuracy];
        sigma_seq = [sigma_seq; S];
    end

    [~,pos] = max(overall_accuracy(:,1)); % Find the peak. 

    % Creating and saving the curve in the current directory.
    plot(sigma_seq,overall_accuracy(:,1),'--ks','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',4)
    title('Sigma vs Accuracy');
    xlabel('SVM classifier: Sigma values');
    ylabel('Overall Classification Accuracy (%)');
    saveas(gca,'svm_tune.bmp');
    
    % Write the peak value on the Textfile.
    fprintf(file_write,'Support Vector Machine: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');
    fprintf(file_write,'Maximum avearge accuracy (in Percentage)    : %0.2f\r\n', overall_accuracy(pos,1));
    fprintf(file_write,'LP detection accuracy (in Percentage)       : %0.2f\r\n', overall_accuracy(pos,2));
    fprintf(file_write,'Non-LP detection accuracy (in Percentage)   : %0.2f\r\n', overall_accuracy(pos,3));
    fprintf(file_write,'Value of Sigma at Max. accuracy : %0.2f\r\n', sigma_seq(pos,1));
    fprintf(file_write,'Overall testing time : %f seconds\r\n', t);

    fclose(file_write); % File closing.
end