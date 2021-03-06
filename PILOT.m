function out = PILOT(X, Y, featlabels, opts)
% -------------------------------------------------------------------------
% PILOT.m
% -------------------------------------------------------------------------
%
% By: Mario Andres Munoz Acosta
%     School of Mathematics and Statistics
%     The University of Melbourne
%     Australia
%     2020
%
% -------------------------------------------------------------------------

errorfcn = @(alpha,X,n,m) nanmean(nanmean((X-(reshape(alpha((2*n)+1:end),m,2)*... % B,C
                                              reshape(alpha(1:2*n),2,n)...        % A
                                              *X(:,1:n)')').^2,1),2);
n = size(X, 2); % Number of features
Xbar = [X Y];
m = size(Xbar, 2);
Hd = pdist(X)';

if opts.analytic
    disp('  -> PILOT is solving analyticaly the projection problem.');
    disp('  -> This won''t take long.');
    Xbar = Xbar';
    X = X';
    [V,D] = eig(Xbar*Xbar');
    [~,idx] = sort(abs(diag(D)),'descend');
    V = V(:,idx(1:2));
    out.B = V(1:n,:);
    out.C = V(n+1:m,:)';
    Xr = X'/(X*X');
    out.A = V'*Xbar*Xr;
    out.Z = out.A*X;
    Xhat = [out.B*out.Z; out.C'*out.Z];
    out.error = sum(sum((Xbar-Xhat).^2,2));
    out.R2 = diag(corr(Xbar',Xhat')).^2;
else
    if ~isfield(opts,'alpha')
        disp('  -> PILOT is solving numerically the projection problem.');
        disp('  -> This may take a while.');
        out.alpha = zeros(2*m+2*n, opts.ntries);
        out.eoptim = zeros(1, opts.ntries);
        out.perf = zeros(1, opts.ntries);
        state = rng;
        rng('default');
        out.X0 = 2*rand(2*m+2*n, opts.ntries)-1;
        rng(state);
        disp('-------------------------------------------------------------------------');
        for i=1:opts.ntries
            [out.alpha(:,i),out.eoptim(i)] = fminunc(errorfcn, out.X0(:,i), ...
                                                     optimoptions('fminunc','Algorithm','quasi-newton',...
                                                                            'Display','off',...
                                                                            'UseParallel',false),...
                                                     Xbar, n, m);
            A = reshape(out.alpha(1:2*n,i),2,n);
            Z = X*A';
            out.perf(i) = corr(Hd,pdist(Z)');
            if i==opts.ntries
                disp(['    -> PILOT has completed trial ' num2str(i) ...
                      '. There are no trials left.']);
            elseif i==opts.ntries-1
                disp(['    -> PILOT has completed trial ' num2str(i) ...
                      '. There is 1 trial left.']);
            else
                disp(['    -> PILOT has completed trial ' num2str(i) ...
                      '. There are ' num2str(opts.ntries-i) ' trials left.']);
            end
        end

        [~,idx] = max(out.perf);
    else
        disp('  -> PILOT is using a pre-calculated solution.');
        idx = 1;
        out.alpha = opts.alpha;
    end
    out.A = reshape(out.alpha(1:2*n,idx),2,n);
    out.Z = X*out.A';
    B = reshape(out.alpha((2*n)+1:end,idx),m,2);
    Xhat = out.Z*B';
    out.C = B(n+1:m,:)';
    out.B = B(1:n,:);
    out.error = sum(sum((Xbar-Xhat).^2,2));
    out.R2 = diag(corr(Xbar,Xhat)).^2;
end

disp('-------------------------------------------------------------------------');
disp('  -> PILOT has completed. The projection matrix A is:');
out.summary = cell(3, n+1);
out.summary(1,2:end) = featlabels;
out.summary(2:end,1) = {'Z_{1}','Z_{2}'};
out.summary(2:end,2:end) = num2cell(round(out.A,4));
disp(' ');
disp(out.summary);

end