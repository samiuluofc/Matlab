function [all_global, all_mean, y_global, y_global_err] = my_particle_swarm(w, c1, c2, x_min, x_max, n_d, n_s, max_iteration)
% -------------------------------------------------------------------------
% The (Particle Swarm Optimization)PSO algorithm is based on Chapter 16
% of reference [1].
% 
% Ref [1]: Computational Intelligence: An Introduction, 2nd Edition by
% Andries P. Engelbrecht.
% -------------------------------------------------------------------------
% @Parameters:
% n_d is the dimension of point x or search space.
% n_s is number of particles.
% x_min and x_max is the range of x values.
% w control the exploration.
% c1 and c2 control the exploitation.
% S is not relate to PSO. Its for the my_ensemble_fitness() function.
% -------------------------------------------------------------------------
% @Return:
% all_global: An array contains globally best fitnesses of all iterations.
% all_mean: An array contains mean fitnesses of all iterations.
% y_global: The best value of x.
% y_global_err: The eroor of best fitness.
% -------------------------------------------------------------------------

    all_global = zeros(max_iteration,1); 	% To store all global-bests of all iterations.
    all_mean = zeros(max_iteration,1);      % To store all mean-errors of all iterations.
    
    x = zeros(n_s,n_d);                     % Particles locations (zero initialization).
    x_err = zeros(n_s,1);                   % Will contain all fitness values (zero initialization).
    
    % Random initialization of all particles using Eqn 16.9 from [1]. 
    for i = 1: n_d
        r = rand(1, n_s); % Uniformly distributed random number [0,1].
        x(:,i) = x_min + (r .* (x_max - x_min));
    end
    
    % Initialization of local best, velocity for all particles. 
    v = zeros(n_s,n_d);                 % Initial velocity using Eqn 16.10 from [1].
    y_local = x;                        % Using Eqn 16.11 from [1].
    y_local_err = ones(n_s,1) .* 100;   % Assign maximum error.
    y_global = x(1,:);                  % First particle (which is a random location) as global best.
    it = 1;
    
    while(it <= max_iteration)
        
        % Calculating individual fitness.
        for i = 1 : n_s
                x_err(i,1) = combine_fitness(x(i,:));
        end
    
        % Updating local best.
        bin = x_err(1:n_s,1) < y_local_err(1:n_s,1);
        y_local_err(bin) = x_err(bin); 
        y_local(bin,:) = x(bin,:); 
        
        
        % Updating global best.
        [y_global_err, pos] = min(y_local_err);
        y_global = y_local(pos,:);

        
        % Random values at time t for each dimension.
        r = zeros(n_d,2);
        for i = 1 : n_d
            r(i,1) = rand();
            r(i,2) = rand();
        end
             
        % Update the velocity at time t for each dimension: using Eqn 16.2 from [1].    
        for i = 1 : n_d
            v(:,i) = (w .* v(:,i)) + (c1 .* r(i,1) .* (y_local(:,i) - x(:,i))) + (c2 .* r(i,2) .* (y_global(1,i) - x(:,i)));   
        end
       
        % Update the velocity: using Eqn 16.2 from [1].
        x = x + v;
        
        % Array update
        all_global(it,1) = y_global_err;
        it = it + 1;    
    end
end
