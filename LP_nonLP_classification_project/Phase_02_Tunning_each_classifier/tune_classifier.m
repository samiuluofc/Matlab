% -------------------------------------------------------------------------
% This program will find the best value of the sensitive parameter for each
% classifier in a simple iterative way. I consider following four
% classifiers and one parameter (sensitive) from each.
% 
% |--Classifier--------------|----Parameter------|
% |--------------------------|-------------------|
% | Support Vector Machine   |      Sigma        |
% | Decision Tree            |      MinLeaf      |
% | Discriminant Analysis    |      Gamma        |
% | K Nearest Neighbor       |      Neighbor     |
% |--------------------------|-------------------|
%
% -------------------------------------------------------------------------
% After running the program, you will get four "txt" files and four "bmp"
% files for each classifier. The "bmp" files show the parameter-vs-accuracy 
% graph for each classifier, and the "txt" files contain information about 
% the peak point (maximum accuracy) of the graphs.
% -------------------------------------------------------------------------
% The execution time of this program is around 10 minutes.
% -------------------------------------------------------------------------

clear % Clear current program memory.
tic() % Time count starts.

% Decision Tree analysis when when all 360 features are considered.........
disp('Tuning Decision Tree .......')
tree_tune();

% K nearest neighbor analysis when all 360 features are considered.........
disp('Tuning K Nearest Neighbor .......')
knn_tune();

% Discriminant analysis when all 360 features are considered...............
disp('Tuning Discriminant Analysis .......')
disa_tune();

% Support Vector Machine analysis when all 360 features are considered.....
disp('Tuning Support Vector Machine .......')
svm_tune();

toc() % Time count ends.