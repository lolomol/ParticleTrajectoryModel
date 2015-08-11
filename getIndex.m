function index=getIndex(x,X)

% getIndex
% -------------
%
% returns index position of elements of x in discrete vector X

tmp = abs( repmat(x,length(X),1) - repmat(X,1,length(x)) );
[c index] = min(tmp);
