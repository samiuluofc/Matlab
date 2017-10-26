% -------------------------------------------------------------------------
% Finding the best combination of weighted prediction using GA in 4D
% (real number) search space. You can do the search for N times.
%
% It generates N number of generation graphs (generation-vs-fitness),
% and a textfile containing classification accuracy and the best
% individual (weight vector).
% -------------------------------------------------------------------------
% The execution time of this program is around 45 minutes when N = 1.
% -------------------------------------------------------------------------

clear;  % Clear current program memory.
tic()   % Time count starts.

% GA Parameters -------------------------------------
C = 0.6;    % Crossover rate.
M = 0.2;    % Mutation rate.
ps = 10;    % Population size
gen = 100;  % Number of generation 
%----------------------------------------------------
N = 5;      % Number of GA calls.

% Set GA options.
option = gaoptimset('PopulationType','doubleVector', 'PopulationSize',ps, 'FitnessLimit',0,...
    'Generations',gen, 'PlotFcns', @gaplotbestf,'StallGenLimit', inf, 'SelectionFcn', @selectionroulette,...
    'CrossoverFcn', @crossoversinglepoint, 'CrossoverFraction', C, 'MutationFcn', {@mutationadaptfeasible, M});

% Open a text file in write mode.
file_write = fopen(strcat('GA_output.txt'),'w'); 

fprintf(file_write,'Mixture of experts model: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');

for i = 1 : 1 : N
    disp('Running GA algorithm for the weight adjustment of Mixture of experts model.....');
    [chro_w,best_w,~]= ga(@combine_fitness,4,[],[],[],[],[0;0;0;0],[1;1;1;1],[],option); % Calling GA function.
    saveas(gca,strcat(int2str(i),'_ensemble_GA.bmp')); % Saving the generation graph.
    fprintf(file_write, strcat('Iteration : (',int2str(i),') -----------------------------------------------------------------------\r\n'));
    fprintf(file_write,'Classification Accuracy in Percentage   : %0.2f %%\r\n', 100 - best_w);
    fprintf(file_write,'The optimal weights (DTree, KNN, DISA, SVM): (%0.4f, %0.4f, %0.4f, %0.4f)\r\n\r\n', chro_w);
end

fclose(file_write); % Closing the file.

toc()   % Time count ends.