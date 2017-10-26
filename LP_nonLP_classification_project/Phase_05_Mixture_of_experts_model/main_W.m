% -------------------------------------------------------------------------
% Using this function, we can try different combination of weighted
% prediction. It gives accuracies for all possible unit combinations
% (4 classifiers, 15 combinations, when equal weight is assigned),
% as well as rank based (either 4, 3, 2, or 1 as per their individual
% performance) weights.
% -------------------------------------------------------------------------
% It generates a text file "W_output.txt" contains classification accuracy
% for different weight vectors.
% -------------------------------------------------------------------------
% The execution time of this program is around 35 seconds.
% -------------------------------------------------------------------------

clear;  % Clear current program memory.
tic()   % Time count starts.

file_write = fopen('W_output.txt','w'); 

disp('Calculating accuracies for different weight vectors...............');
fprintf(file_write,'Weight vector (Dtree,KNN,DISA,SVM)----Accuracy in %%\r\n');
fprintf(file_write,'---------------------------------------------------\r\n');
fprintf(file_write,'weight combination (1, 1, 0, 0):      %0.2f %%\r\n', 100 - combine_fitness([1, 1, 0, 0]));
fprintf(file_write,'weight combination (0, 1, 1, 0):      %0.2f %%\r\n', 100 - combine_fitness([0, 1, 1, 0]));
fprintf(file_write,'weight combination (0, 0, 1, 1):      %0.2f %%\r\n', 100 - combine_fitness([0, 0, 1, 1]));
fprintf(file_write,'weight combination (1, 0, 0, 1):      %0.2f %%\r\n', 100 - combine_fitness([1, 0, 0, 1]));
fprintf(file_write,'weight combination (0, 1, 0, 1):      %0.2f %%\r\n', 100 - combine_fitness([0, 1, 0, 1]));
fprintf(file_write,'weight combination (1, 0, 1, 0):      %0.2f %%\r\n', 100 - combine_fitness([1, 0, 1, 0]));
fprintf(file_write,'weight combination (1, 0, 1, 1):      %0.2f %%\r\n', 100 - combine_fitness([1, 0, 1, 1]));
fprintf(file_write,'weight combination (0, 1, 1, 1):      %0.2f %%\r\n', 100 - combine_fitness([0, 1, 1, 1]));
fprintf(file_write,'weight combination (1, 1, 0, 1):      %0.2f %%\r\n', 100 - combine_fitness([1, 1, 0, 1]));
fprintf(file_write,'weight combination (1, 1, 1, 0):      %0.2f %%\r\n', 100 - combine_fitness([1, 1, 1, 0]));
fprintf(file_write,'weight combination (1, 1, 1, 1):      %0.2f %%\r\n', 100 - combine_fitness([1, 1, 1, 1]));
fprintf(file_write,'weight combination (1, 4, 2, 3):      %0.2f %%\r\n', 100 - combine_fitness([2, 3, 1, 4]));

fclose(file_write); % Closing the file.

toc()   % Time count ends.