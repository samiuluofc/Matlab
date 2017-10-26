function [out,p] = my_svmdecision(Xnew,svm_struct)
%SVMDECISION Evaluates the SVM decision function

%   Copyright 2004-2010 The MathWorks, Inc.
%   $Revision: 1.1.24.1 $  $Date: 2011/12/27 15:39:44 $

sv = svm_struct.SupportVectors;
alphaHat = svm_struct.Alpha;
bias = svm_struct.Bias;
kfun = svm_struct.KernelFunction;
kfunargs = svm_struct.KernelFunctionArgs;

f = (feval(kfun,sv,Xnew,kfunargs{:})'*alphaHat(:)) + bias;

% Modified the values of f to get the probability
temp = (f.*-1);
temp = temp - min(f);
p = temp./max(temp); % P is the probability

out = sign(f);
% points on the boundary are assigned to class 1
out(out==0) = 1;