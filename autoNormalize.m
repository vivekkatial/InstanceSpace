function [X,Y,out] = autoNormalize(X, Y, opts)

nfeats = size(X,2);
nalgos = size(Y,2);
if opts.flag
    disp('-> Auto-normalizing the data using Box-Cox and Z transformations.');
    out.minX = min(X,[],1);
    X = bsxfun(@minus,X,out.minX)+1;
    out.lambdaX = zeros(1,nfeats);
    for i=1:nfeats
        [X(:,i), out.lambdaX(i)] = boxcox(X(:,i));
    end
    [X, out.muX, out.sigmaX] = zscore(X);
    
    Y(Y==0) = eps;
    out.lambdaY = zeros(1,nalgos);
    out.muY = zeros(1,nalgos);
    out.sigmaY = zeros(1,nalgos);
    for i=1:nalgos
        aux = Y(:,i);
        idx = isnan(aux);
        [aux, out.lambdaY(i)] = boxcox(aux(~idx));
        [aux, out.muY(i), out.sigmaY(i)] = zscore(aux);
        Y(~idx,i) = aux;
    end
else
    out.lambdaX = ones(1,nfeats);
    out.muX = zeros(1,nfeats);
    out.sigmaX = ones(1,nfeats);
    out.lambdaY = ones(1,nalgos);
    out.muY = zeros(1,nalgos);
    out.sigmaY = ones(1,nalgos);
end

end