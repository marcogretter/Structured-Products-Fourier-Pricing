function f_t = logreturns_MC_point_3(n_simu, mu, p_plus, p_minus)
% This function has the goal to do the MonteCarlo simulation for point 3c.
% As written in the report we need to simulate the paths of two
% exponential rvs.

%% Inputs:
% n_simu:   number of simulations

%% Outputs:
% f_t:      simulated log-return

% We know that if X~Unif(0,1), then -log(X)~Exp(1), then we simulate the
% paths
% e_1 ~ Exp(p_plus)
% e_2 ~ Exp(-p_minus)

e_1 = rand(n_simu,1);
e_2 = rand(n_simu,1);

e_1 = -log(e_1) ./ p_plus;
e_2 = -log(e_2) ./ (p_minus);

f_t = mu + e_1 - e_2;

