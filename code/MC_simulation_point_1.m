function payoff = MC_simulation_point_1(n_simu, r, P,T_anni)
% This function has te678i

% Monte Carlo simulations to derive the path of Eni and AXA
% Market data
S0 = [12.3, 22.1];
sigma = [0.201, 0.183];
div = [0.032, 0.029];
rho = 0.49;
alpha = 1.10;

% Correlated randoms
Z = randn(n_simu,2);
L = chol([1 rho; rho 1],'lower');
Zcorr = Z * L';        % correlate shocks

% Simulate terminal prices
ST = zeros(n_simu,2);
for i=1:2
    ST(:,i) = S0(i) .* exp((r - div(i) - 0.5*sigma(i)^2)*T_anni + sigma(i)*sqrt(T_anni)*Zcorr(:,i));
end

% Basket performance e payoff
S_T = 0.5 * (ST(:,1)./S0(1) + ST(:,2)./S0(2));
payoff = alpha * max(S_T - P, 0);