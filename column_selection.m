function [columns VbarT alpha flag]= column_selection(WT,EpsT,VbarT,lambda,alpha0)

% choose regularization parameter lambda, initial steplength alpha0. 

epstol=1.e-6;  % terminate when relative change in F drops below epstol
convergence=0; % convergence flag
itmax=1000;    % maximum number of iterations
btmax=50;      % max number of backtracking steps
alpha_min=1.e-20;  % crash out when alpha drops below this threshold
flag=0;        % flag=0 means no error on exit

r2 = size(WT,2);
n = size(EpsT,2);
fprintf(1,' r^2=%d, n=%d\n', r2,n);

% VbarT = zeros(r2,n);
VnewT=VbarT;
  
% evaluate initial function value
Temp=WT*VbarT-EpsT;
Fval=0.5*trace(Temp'*Temp);
for i=1:r2
  Fval=Fval+lambda*norm(VbarT(i,:));
end
fprintf(1,' initial F=%12.7e\n', Fval);
alpha=alpha0;

for iter=1:itmax
  G = WT*VbarT-EpsT;
  G = WT'*G;

  for ia=1:btmax
    R = VbarT-alpha*G;;
    zero_rows=0;
    for i=1:r2
      nRi=norm(R(i,:),2);
      if (nRi<=alpha*lambda)
        VnewT(i,:) = zeros(1,n);
        zero_rows=zero_rows+1;
%         fprintf(1,' %2d  ||V(i,:)||=%10.5e ||Vnew(i,:)||=%10.5e\n', i, norm(VbarT(i,:)), norm(VnewT(i,:)));
      else
        VnewT(i,:) = (1.0-(alpha*lambda)/nRi)*R(i,:);
%        fprintf(1,' %2d  ||V(i,:)||=%10.5e ||Vnew(i,:)||=%10.5e\n', i, norm(VbarT(i,:)), norm(VnewT(i,:)));
      end
    end
%     fprintf(1,' ||V-Vnew||=%10.4e\n', norm(VbarT-VnewT,'fro'));
    % evaluate the function at the proposed new iterate
    Temp=WT*VnewT-EpsT;
    Fval_new=0.5*trace(Temp'*Temp);
    for i=1:r2
      Fval_new=Fval_new+lambda*norm(VnewT(i,:),2);
    end
    fprintf(1,' alpha=%10.3e, F-Fnew=%12.7e,   zero rows=%d\n', ...
            alpha, Fval-Fval_new, zero_rows);
    if (Fval_new < Fval)
      fprintf(1,' success with alpha=%10.3e\n', alpha);
      break;
    else
      alpha=0.5*alpha;
      if (alpha<alpha_min)
        break;   % alpha too small - crash out.
      end
    end
  end
  
  % did backtracking fail?
  if (ia==btmax) | (alpha<alpha_min)
    fprintf(1,' backtracking failed!\n');
    flag=1;
    break;
  end
  
  % backtracking succeeded! Take the step
  alpha=1.5*alpha; % increase alpha slightly for next iteration
  if (abs(Fval_new-Fval)/abs(Fval) <= epstol)
    convergence=1;
  end
  Fval=Fval_new; VbarT=VnewT;
  fprintf(1,'\n iter %d, F= %12.7e, zero rows: %d of %d\n', iter, Fval, zero_rows, r2);
  
  % print row norms
%  for i=1:r2
%    fprintf(1,' %2d  ||V(i,:)||=%10.5e\n', i, norm(VbarT(i,:)));
%  end
  
  if (convergence==1) 
    fprintf(1,' convergence! - stop\n');
    break;
  end
end

% debiasing - mostly turned off for now - just fill out the index
% array "columns" indicating which columes were selected.

columns = [];
if (convergence==1) 
%   q = 0;
%   Scheck=[];
  for i=1:r2
    if (norm(VbarT(i,:))>1.e-6)
%       q=q+1;
%       Scheck=[Scheck WT(:,i)];
      columns = [columns, i];
    end
  end
%   VbarT= Scheck\EpsT;
end

end