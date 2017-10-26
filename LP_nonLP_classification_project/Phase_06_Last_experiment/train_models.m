% -------------------------------------------------------------------------
% This program will train each classifier using the selected features
% (resides in the "chromosome.mat" file), and all CLP images of size 1x.
% 2-fold cross validation is not used here. It generates a model for
% each classifier.
% -------------------------------------------------------------------------
% Total 04 "mat" files will be generated that contain trained models.
% We will use these models in the mixture of experts model.
% -------------------------------------------------------------------------
% The execution time of this program is around 6 seconds.
% -------------------------------------------------------------------------

clear % Clear current program memory.
tic() % Time count starts.

disp('Generating models ....');  

load chromosome.mat % Loading selected (using GA) chromosomes for each classifier. 
load LP_1x.mat      % All simple HOG features (length 360) of all 540 LP images (size 1x).
load nonLP_1x.mat   % All simple HOG features (length 360) of all 1820 Non-LP images (size 1x).

LP1 = [LP1x(1:540,:), ones(540,1)];             % LP means 1.
nonLP1 = [nonLP1x(1:1820,:), zeros(1820,1)];    % non-LP means 0.

% Output labels.
Y_train = LP1(1:540,361);
Y_train = [Y_train; nonLP1(1:1820,361)];

% DISA training.
% Making Training data.
X_train = LP1(1:540,logical(chro_disa));
X_train = [X_train; nonLP1(1:1820,logical(chro_disa))];

gamma = 0.08; % Value of gamma (for DISA classifier).
my_disa = ClassificationDiscriminant.fit(X_train, Y_train, 'gamma',gamma);
save disa.mat my_disa % Saving the model.


%D-TREE training.
% Making Training data.
X_train = LP1(1:540,logical(chro_tree));
X_train = [X_train; nonLP1(1:1820,logical(chro_tree))];

leaf = 5; % Value of Minleaf (for DTree classifier).
my_tree = ClassificationTree.fit(X_train, Y_train, 'MinLeaf',leaf);
save tree.mat my_tree % Saving the model.

%KNN training.
% Making Training data.
X_train = LP1(1:540,logical(chro_knn));
X_train = [X_train; nonLP1(1:1820,logical(chro_knn))];

N = 15; % Value of neighbor (for KNN classifier).
my_knn = ClassificationKNN.fit(X_train, Y_train, 'NumNeighbors',N);
save knn.mat my_knn % Saving the model.


%SVM training.
% Making Training data.
X_train = LP1(1:540,logical(chro_svm));
X_train = [X_train; nonLP1(1:1820,logical(chro_svm))];

S = 5.6; % Value of Sigma (for SVM classifier).
op = statset('MaxIter',30000);
my_svm = svmtrain(X_train, Y_train,'Kernel_Function', 'rbf', 'rbf_sigma',S,'options',op);
save svm.mat my_svm

toc() % Time count ends.
