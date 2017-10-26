function err = combine_fitness(w)
% -------------------------------------------------------------------------
% Fitness function for both GA and PSO, where combined error is consider as
% fitness measure. Here, we are tesing the mixture of expert-models with 
% 2x and hx size of the original CLP images. It takes a weight vector (of 
% length 4) as a function parameter.
% -------------------------------------------------------------------------

 %err1 = my_ensemble_fitness(w,'h');
 %err2 = my_ensemble_fitness(w,'2');
 
 %err = (err1+err2)./2; % Combined error.
 err = my_ensemble_fitness(w,'1');
end

