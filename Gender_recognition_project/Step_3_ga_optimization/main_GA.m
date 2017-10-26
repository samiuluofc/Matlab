% In this program, Genetic algorithm will find the optimal weight vector 
% for the mixture of experts (SVM, KNN, LASSO and DTree) model. The program
% will display the maximized accuracy and the optimal weight vector.

clear;
tic()

% GA parameters --------------------------------------
C = 0.5;    % Crossover rate.
M = 0.5;    % Mutation rate.
gen = 100;  % Number of generations to run.
ps = 10;    % Population size.
% ----------------------------------------------------

% Set GA options.
option = gaoptimset('PopulationType','doubleVector', 'PopulationSize',ps, 'FitnessLimit',0,...
    'Generations',gen, 'PlotFcns', @gaplotbestf,'StallGenLimit', inf, 'SelectionFcn', @selectionroulette,...
    'CrossoverFcn', @crossoversinglepoint, 'CrossoverFraction', C, 'MutationFcn', {@mutationadaptfeasible, M});

N = 5; % Set how many times you want execute GA stochastic algorithm

for i = 1 : 1 : N 
    % "best_weight" contains the optimal weight vector.
    % "error" contains the minimized error value.
    [best_weight,error,~]= ga(@fitness_mix,4,[],[],[],[],[0;0;0;-1],[1;1;1;1],[],option); % Invoked GA function
    
    saveas(gca,strcat('GA_',int2str(i),'.pdf'));% Saving generation graph
    
    disp('Accuracy (in %):');
    disp((1-error)*100);
    disp('Weights :');
    disp(best_weight);
end
toc()