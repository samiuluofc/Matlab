% This main program will do SBS feature selection for KNN with the help of
% knn_fitness function. The variable "bin" contains all the selected and 
% unselected features.

clear();
tic();

% Initialization
bin = true(1,57); % Select all features (57 dimension) at the beginning.
err = fitness_knn(bin); % Initial error value

% Iteratively, removes one feature at a time, if the removal reduces
% average prediction error of 5 different experiments.
for i = 1:1:57 % 57 dimensional feature vector
    new_bin = bin;
    new_bin(1,i) = false; % remove a feature
    
    err_new = fitness_knn(new_bin); % calculate average error
   
    % Update the selection
    if err_new <= err
        err = err_new;
        bin = new_bin; 
    end
end

bin % Show all selected and unselected features in the CLI.
% Copy them into a text file to use them later.

toc();