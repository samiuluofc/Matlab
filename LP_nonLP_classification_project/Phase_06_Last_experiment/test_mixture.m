% -------------------------------------------------------------------------
% Befor running this program you need to generate the models using
% "train_models.m" program.
% -------------------------------------------------------------------------
%
% In this program, we test our mixture of experts model with the weight
% vector found by PSO algorithm. The test is done for all CLP data
% (1x, 2x and hx).
% -------------------------------------------------------------------------
%  
% It will generate a textfile "output.txt" that contains the accuracies.
% The execution time of this program is around 08 seconds.
% -------------------------------------------------------------------------

clear % Clear current program memory.
tic() % Time count starts.


% Open a text file in write mode.
file_write = fopen('output.txt','w'); 

disp('Testing mixture of experts model .........');
fprintf(file_write,'Mixture of experts model: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\r\n\r\n');

fprintf(file_write, 'Accuracy for 1x resolution of CLPs : %0.2f %%\r\n', mixture_fitness([0.5788, 2.0888, 0.0759, -0.3240],'1'));
fprintf(file_write, 'Accuracy for hx resolution of CLPs : %0.2f %%\r\n', mixture_fitness([0.5788, 2.0888, 0.0759, -0.3240],'h'));
fprintf(file_write, 'Accuracy for 2x resolution of CLPs : %0.2f %%\r\n', mixture_fitness([0.5788, 2.0888, 0.0759, -0.3240],'2'));

toc() % Time count ends.