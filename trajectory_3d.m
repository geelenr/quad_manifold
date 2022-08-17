clc; clear; close all;

%% problem setup

% model parameters
s = @(t) [cos(t); sin(t); 0.5*cos(2*t)]; % trajectory
nsamples = 100; % number of data points
r = 2; % reduced basis dimension
sref = s(0); % reference state
lambda = 0; % regularization

% construct trajectory
t_end = 2*pi;
t = 0:t_end/(nsamples-1):t_end;
trajectory = s(t);

%% left singular vectors

[U,S,~] = svd(trajectory-sref,'econ'); % svd
Vr = U(:,1:r); % POD basis matrix

%% linear dimensionality reduction

% compute approximated trajectory with linear subspace approach
srec = sref + Vr*Vr'*(trajectory-sref);

%% data-driven quadratic solution-manifolds

shat = Vr'*(trajectory-sref);
err = trajectory-sref-Vr*shat; % linear projection error
W = get_x_sq(shat')';
Wtilde = W([1,2,3],:); % column selection (if applicable)
[q,~] = size(err); 
[p,~] = size(Wtilde);
Aplus = [Wtilde'; sqrt(lambda)*eye(p)];
bplus = [err'; zeros(p,q)];
Vbar = (Aplus\bplus)';
srec_quad = sref + Vr*shat + Vbar*Wtilde;

%% compute error

err      = norm(srec     -trajectory, 'fro')/norm(trajectory, 'fro');
err_quad = norm(srec_quad-trajectory, 'fro')/norm(trajectory, 'fro');
fprintf("Reconstruction error linear model: \t%s\n", err);
fprintf("Reconstruction error quadratic model: \t%s\n", err_quad);

%% plotting

% linear
figure('Position', [10 10 300 350]);
h = scatter3(trajectory(1,:), trajectory(2,:), ...
    trajectory(3,:),'filled','k'); hold on;
set(h,'MarkerEdgeAlpha',0.5,'MarkerFaceAlpha',0.7,'SizeData',8)
plot3(srec(1,:), srec(2,:), srec(3,:),'.','color','#006eb8');
xlabel('$s_1$','interpreter','latex'); 
ylabel('$s_2$','interpreter','latex'); 
zlabel('$s_3$','interpreter','latex');
[X,Y] = meshgrid(-2.5:0.1:2.5,-2.5:0.1:2.5);
Z = ones(size(X)); sz = size(X,1)*size(X,2);
surf1 = [reshape(X,1,sz); reshape(Y,1,sz); reshape(Z,1,sz)];
surf1_rec = sref + Vr*Vr'*(surf1-sref);
surf1_rec_mat1 = reshape(surf1_rec(1,:),size(X,1),size(X,2));
surf1_rec_mat2 = reshape(surf1_rec(2,:),size(Y,1),size(Y,2));
surf1_rec_mat3 = reshape(surf1_rec(3,:),size(Z,1),size(Z,2));
mesh(surf1_rec_mat1,surf1_rec_mat2,surf1_rec_mat3,'FaceAlpha','0.05', ...
    'EdgeColor','#006eb8','FaceColor','#006eb8','LineStyle',':');
axis([-1.25 1.25 -1.25 1.25 -1 1]); view(-50, 25);
legend('trajectory $\mathbf{s}(t)$','approximated trajectory', ...
    'linear manifold','interpreter','latex','location','southoutside');
legend boxoff; grid on; set(gca,'GridLineStyle','--');

% quadratic
figure('Position', [10 10 300 350]);
h = scatter3(trajectory(1,:), trajectory(2,:), ...
    trajectory(3,:),'filled','k'); hold on;
set(h,'MarkerEdgeAlpha',0.5,'MarkerFaceAlpha',0.7,'SizeData',8)
plot3(srec_quad(1,:), srec_quad(2,:), srec_quad(3,:),'.','color','#ee2967');
xlabel('$s_1$','interpreter','latex'); 
ylabel('$s_2$','interpreter','latex'); 
zlabel('$s_3$','interpreter','latex');
W = get_x_sq((Vr'*(surf1-sref))')';
Wtilde = W([1,2,3],:);
surf2_rec = sref + Vr*Vr'*(surf1-sref) + Vbar*Wtilde;
surf2_rec_mat1 = reshape(surf2_rec(1,:),size(X,1),size(X,2));
surf2_rec_mat2 = reshape(surf2_rec(2,:),size(Y,1),size(Y,2));
surf2_rec_mat3 = reshape(surf2_rec(3,:),size(Z,1),size(Z,2));
mesh(surf2_rec_mat1,surf2_rec_mat2,surf2_rec_mat3,'FaceAlpha','0.1', ...
    'EdgeColor','#ee2967','FaceColor','#ee2967','LineStyle',':');
axis([-1.25 1.25 -1.25 1.25 -1 1]); view(-50, 25);
grid on;
set(gca,'GridLineStyle','--');
legend('trajectory $\mathbf{s}(t)$','approximated trajectory', ...
    'quadratic manifold', 'interpreter','latex','location','southoutside');
legend boxoff; grid on; set(gca,'GridLineStyle','--');

% latex stuff
set(gca,'defaulttextinterpreter','latex');  
set(groot,'defaultAxesTickLabelInterpreter','latex', ...
    'defaultLegendInterpreter','latex');  