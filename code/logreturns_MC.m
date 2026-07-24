function f_t = logreturns_MC(kappa, eta, ttm, sigma, n_simu)
% This function has the goal to compute the price of an option using MC 
% simulations for g and G, where g is a std Normal, and G is an inverse 
% gaussian since we are in the NIG case

%% Inputs:
% kappa:    curtosis
% eta:      skewness
% ttm:      time to maturity
% sigma:    volatility
% n_simu:   number of simulations

%% Outputs:
% f_t:      simulated log-return

% Analytic solution for Laplace exponent seen in class (NIG case):
% In the beginning I computed the ln of the Laplace transform because I was
% implementing letter by letter the formulas seen in class. I mean, it's
% still correct, but maybe the best was to compute the Laplace transform
% and not the ln of the Laplace transform. 
% The important thing is remembering that it is the ln, also I wrote
% lne_L and not L
lne_L = @(omega) (ttm/kappa) .* (1 - sqrt(1 + (2.*omega.*kappa.*(sigma^2))));

% From the martingale condition (WP) we know the value of mu:
mu = - lne_L(eta);

% We generate the simulations for g, which is a std normal:
g = randn(n_simu, 1);

% To simulate G (Inverse Gaussian), we follow the slides, so: 
% wee simulate a uniform u in (0,1):
u = rand(n_simu,1);
% We know that z is a chi-quadro, which is, in the case of a std normal rv,
% the square of the std normal rv:
z = randn(n_simu,1);
z = z.^2;

% We write the formula for G*:
G_star = 1 - (kappa/2).*(sqrt((z.^2) + (4.*z./kappa)) - z);

% Third step in order to find G:
condizione = (1 + G_star) .* u > 1;   
G = zeros(n_simu, 1);
G(condizione) = 1 ./ G_star(condizione);
G(~condizione) = G_star(~condizione);

% Now that we have all we need we can compute f_t:
f_t = -(0.5+eta)*(sigma^2)*ttm.*G + sigma*sqrt(ttm*G).*g + mu;





