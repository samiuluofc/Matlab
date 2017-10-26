% -------------------------------------------------------------------------
% This program will apply binary chromosome based Genetic Algorithm (GA) 
% for feature selection of each classifier. After running the program it 
% will generate one textfile "Output.txt" contains performance of the best
% individual for each classifier and four "bmp" images contain generation
% graph for each classifier. Also it saves the best chromosome of all four
% classifiers into a Matlab data file "chromosome.mat".
% -------------------------------------------------------------------------
% The execution time of this program is around 3 hours (When population 
% size is 10, and number of genration is 100).
% -------------------------------------------------------------------------
% If you want to change the parameters of GA, just assign new value to
% varibale C (crossover rate), M (mutatiom rate), gen (# of generations) 
% and ps (population size). You will get this variables at the beginning
% of this code.
% -------------------------------------------------------------------------

clear % Clear program memory.
tic() % Time count starts.

% GA parameters --------------------------------------
C = 0.6;    % Crossover rate.
M = 0.2;    % Mutation rate.
gen = 100;  % Number of generations to run.
ps = 10;    % Population size.
% ----------------------------------------------------

% Set GA options.
option = gaoptimset('PopulationType','bitstring', 'PopulationSize',ps, 'FitnessLimit',0,...
    'Generations',gen, 'PlotFcns', @gaplotbestf,'StallGenLimit', inf, 'SelectionFcn', @selectionroulette,...
    'CrossoverFcn', @crossoversinglepoint, 'CrossoverFraction', C, 'MutationFcn', {@mutationuniform, M});

% Open a text file in write mode.
file_write = fopen('Output.txt','w'); 

disp('Running GA algorithm for feature selection of Discriminant Analysis Classifier.....');
[chro_disa,best_disa,~]= ga(@disa_fitness,360,[],[],[],[],[],[],[],option); % Calling GA function.
saveas(gca,'disa_GA.bmp'); % Saving the generation graph.
fprintf(file_write,'Discriminant Analysis: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');
fprintf(file_write,'Best Fitness value (Error in Percentage): %0.2f\r\n', best_disa);
fprintf(file_write,'Number of features selected (out of 360): %0.0f\r\n\r\n', sum(chro_disa));

disp('Running GA algorithm for feature selection of K-Nearest-Neighbor Classifier.....');
[chro_knn,best_knn,~]= ga(@knn_fitness,360,[],[],[],[],[],[],[],option); % Calling GA function.
saveas(gca,'knn_GA.bmp'); % Saving the generation graph.
fprintf(file_write,'K Nearest Neighbor: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');
fprintf(file_write,'Best Fitness value (Error in Percentage): %0.2f\r\n', best_knn);
fprintf(file_write,'Number of features selected (out of 360): %0.0f\r\n\r\n', sum(chro_knn));

disp('Running GA algorithm for feature selection of Decision Tree Classifier.....');
[chro_tree,best_tree,~]= ga(@tree_fitness,360,[],[],[],[],[],[],[],option); % Calling GA function.
saveas(gca,'tree_GA.bmp'); % Saving the generation graph.
fprintf(file_write,'Decision Tree: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');
fprintf(file_write,'Best Fitness value (Error in Percentage): %0.2f\r\n', best_tree);
fprintf(file_write,'Number of features selected (out of 360): %0.0f\r\n\r\n', sum(chro_tree));

disp('Running GA algorithm for feature selection of SVM Classifier.....');
[chro_svm,best_svm,~]= ga(@svm_fitness,360,[],[],[],[],[],[],[],option); % Calling GA function.
saveas(gca,'svm_GA.bmp'); % Saving the generation graph.
fprintf(file_write,'Support Vector Machine: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');
fprintf(file_write,'Best Fitness value (Error in Percentage): %0.2f\r\n', best_svm);
fprintf(file_write,'Number of features selected (out of 360): %0.0f\r\n\r\n', sum(chro_svm));

% Saving best chromosome of each classifiers into a Matlab data file.
save chromosome.mat chro_svm chro_tree chro_knn chro_disa

fclose(file_write); % Closing the file.
toc()               % Time count ends.