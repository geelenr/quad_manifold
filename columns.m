function cols = columns(W,Eps)

r2 = size(W,1);
n  = size(Eps,1);
max_lambdas=100;
lambda_fac=0.99;
alpha0=1.e-6;   % initial alpha, not too important

% evaluate gradient of the fitting part at Vbar=0. This determines the
% starting value of lambda
G = W*Eps';
max2norm=0.0;
for i=1:r2
  max2norm=max(max2norm, norm(G(i,:),2));
end
fprintf(1,' max ||W*Eps^T|| row norm is %10.5e\n', max2norm);


VbarT=zeros(r2,n);  % initialize VbarT to zero the first iteration
lambda = max2norm;  % for this lambda, the solution is VbarT=0, so
                    % choose smaller lambda values than this in the
                    % loop below;

for i=1:max_lambdas
  lambda=lambda_fac*lambda;
  [columns VbarT alpha_end flag]= column_selection(W',Eps',VbarT,lambda,alpha0);
  if (flag==1)
    fprintf(1,' ERROR in column_selection for lambda = %10.5e\n', lambda);
    break;
  end
  fprintf(1,'\n\n **** lambda=%12.5e, columns selected: %d\n', ...
          lambda, length(columns));
  fprintf(1,' Columns selected:\n');
  columns
  alpha0=2*alpha_end;
  if (length(columns)>1)
    break;  % quit if we are selecting most of the columns
  end
end

cols = columns;

end