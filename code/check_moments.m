function check_moments(f_t, eta, sigma, ttm, kappa)
% This function makes the check on the moments as requested by the
% Assignment for point 4

% Empirical Moments
emp_mean = mean(f_t);
emp_var  = var(f_t);
emp_skew = skewness(f_t);
emp_kurt = kurtosis(f_t);

% Analytical moments with Laplace transform
syms u

% Theta parameter
theta = -(0.5 + eta) * sigma^2;

% Cumulant Generating Function (CGF) del log-rendimento f_t
% È il logaritmo della trasformata di Laplace del processo mixture
mu_total = - (ttm/kappa) * (1 - sqrt(1 + 2*eta*kappa*sigma^2));
K_u = mu_total * u + (ttm / kappa) * (1 - sqrt(1 - 2 * kappa * (theta * u + 0.5 * sigma^2 * u^2)));

% cumulants
c1 = double(subs(diff(K_u, u, 1), u, 0));
c2 = double(subs(diff(K_u, u, 2), u, 0));
c3 = double(subs(diff(K_u, u, 3), u, 0));
c4 = double(subs(diff(K_u, u, 4), u, 0));

% From cumulants to moments
ana_mean = c1;
ana_var  = c2;
ana_skew = c3 / (c2^(1.5));
ana_kurt = (c4 / (c2^2)) + 3; % +3 per passare da Excess Kurtosis a Pearson Kurtosis


fprintf('\n--- CONFRONTO MOMENTI (N_simu = %d) ---\n', length(f_t));
fprintf('          Empirical   |   Analytical\n');
fprintf('Mean:    %10.6f | %10.6f\n', emp_mean, ana_mean);
fprintf('Variance: %10.6f | %10.6f\n', emp_var, ana_var);
fprintf('Skewness: %10.6f | %10.6f\n', emp_skew, ana_skew);
fprintf('Curtosis:  %10.6f | %10.6f\n', emp_kurt, ana_kurt);