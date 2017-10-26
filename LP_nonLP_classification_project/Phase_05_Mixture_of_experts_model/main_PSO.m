% -------------------------------------------------------------------------
% Finding the best combination of weighted prediction using PSO in 4D
% (real number) search space. You can call the PSO search for N times.
% 
% It generates N number of iteration graphs (fitness-vs-iteration),
% and a textfile containing classification accuracy and the best
% individual (weight vector).
% -------------------------------------------------------------------------
% The execution time of this program is around 50 minutes when N = 1.
% -------------------------------------------------------------------------

clear;  % Clear current program memory
tic()   % Time count starts

% PSO parameters---------------------------------------------------
iter = 100;     % Number of iteration.
w = 0.6;        % Control the inertia velocity (momentum). 
c1 = 0.4;       % Control the cognitive velocity (local best).
c2 = 0.4;       % Control the social velocity (global best).
ns = 10;        % Number of Particles.
%------------------------------------------------------------------
N = 5; % Number of PSO calls.

% Open a text file in write mode.
file_write = fopen('PSO_output.txt','w'); 

fprintf(file_write,'Mixture of experts model: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');

for i = 1 : 1 : N
    disp(strcat('PSO Call (',int2str(i),')----------------------------------------------------------------------'));
    disp('Running PSO algorithm for adjusting the weights of the Mixture of experts model...');

    % Calling PSO algorithm
    [all_global_err, all_mean_err, best_w, best_fit] = my_particle_swarm(w,c1,c2,-5,5,4,ns,iter);

    % Ploting iteration graph.
    plot(1:iter,all_global_err,'--ks','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',4);
    title('Iteration vs Accuracy');xlabel('PSO: Iterations');ylabel('PSO: Classification Error (%)');
    saveas(gca,strcat(int2str(i),'_ensemble_PSO.bmp')); % Saving the iteration graph.

    % Writing best fitness and optimal weight vector into a text file.
    fprintf(file_write, strcat('PSO Call : (',int2str(i),') -----------------------------------------------------------------------\r\n'));
    fprintf(file_write,'Classification Accuracy in Percentage      : %0.2f %%\r\n', 100 - best_fit);
    fprintf(file_write,'The optimal weights (DTree, KNN, DISA, SVM): (%0.4f, %0.4f, %0.4f, %0.4f)\r\n\r\n', best_w);    
end

fclose(file_write); % Closing the file.

toc() % Time count ends.