% -------------------------------------------------------------------------
% This program will train (2 fold cross-validation) each classifier
% using the selected features (resides in the "chromosome.mat" file).
% It generates 2 models (as because of 2 fold) for each classifier.
% -------------------------------------------------------------------------
% Total 8 "mat" files will be generated that contain all trained
% models. We will use these models in the next phase.
% -------------------------------------------------------------------------
% The execution time of this program is around 4 seconds.
% -------------------------------------------------------------------------

clear % Clear current program memory.
tic() % Time count starts.

% Loading selected chromosomes for each classifier. 
load chromosome.mat

disp('Dtree: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp('Generating models ....');
tree_models(chro_tree);

disp('KNN: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp('Generating models ....');
knn_models(chro_knn);

disp('DISA: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp('Generating models ....');
disa_models(chro_disa);

disp('SVM: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
disp('Generating models ....');
svm_models(chro_svm);

toc() % Time count ends.