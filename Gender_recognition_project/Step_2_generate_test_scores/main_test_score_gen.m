% This program will precalculate all the gender prpbabilities for all
% four classifiers (SVM, KNN, TREE, LASSO) for the test data (50 random selected person x 5 times)
% The file "score.mat" will contain all the generated probabilities.

clear();
tic();

% Selected features from SBS
dtree_chro = [true,true,true,true,true,true,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,true,true,true,true];
knn_chro = [false,true,true,true,true,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,true,true,false,true,true,true,true,true,true,false,true,true,true,true,true,true,true,false,true,true];
svm_chro = [true,true,true,true,true,true,true,true,true,false,true,true,true,true,false,true,true,true,false,true,true,true,false,true,true,true,false,true,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,true,true,true];
lasso_chro = true(1,57); % All features for LASSO, as it will select features by itself (using weights).

% Generated probabilities (or scores) for 50 test persons in 5 different
% experiments (random selection of 50 persons).
SVM_score = fitness_svm(svm_chro);
KNN_score = fitness_knn(knn_chro);
TREE_score = fitness_tree(dtree_chro);
LASSO_score = fitness_lasso(lasso_chro);

score = [SVM_score, KNN_score, TREE_score, LASSO_score]; % Appending all scores

save score.mat score % score matrix has 4 columns (SVM, KNN, TREE, LASSO) 
% and (50 persons x 5 experiments) = 250 rows. 

toc();