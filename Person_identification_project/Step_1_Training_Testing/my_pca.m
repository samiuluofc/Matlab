function [U,Z,k] = my_pca(X,T)
% PCA: Principle component analysis
% X is the input dataset.
% T is the amount of variance to neglect. 
% If T is 0.01. That means 99% variance is retained.
% If T is 0.05. That means 95% variance is retained.
% If T is 0.10. That means 90% variance is retained.

% Z = dimention reduced version of X
% k = number of components 

[m n] = size(X);
% m = number of rows or training samples
% n = number of columns or features

% First calculate the covariance matrix (called SIGMA matrix)
sigma = (X' * X)./m; % A n by n matrix

%Calculate the eigenvectors of matrix sigma
[U,S,V] = svd(sigma); % U will be a n by n matrix

% Find the best value of k (number of components to take)
S = diag(S); % take the diagonal elements. Others are actually zeros.

sum_S = sum(S);
sum_C = cumsum(S); % Cummalative sum

var = 1-(sum_C./sum_S); % Variance for all k's (1 to n)
%stem(var);
var_th = var <= T; % Thresholding the variances

k = find(var_th,1); % Find the index of first non-zero element 
% So k is the number of selected principle components based on T

%plot(1:n,var);

U_reduce = U(:,1:k); % A n by k matrix
Z = X * U_reduce; % A m by k matrix (reduced version of X)

end

