function [X,Y]=shuffle_data(X,Y)
idx=randperm(size(X,2))';
X=X(:,idx);
Y=Y(:,idx);
