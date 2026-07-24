function I = quadrature(kappa, eta, ttm, sigma, x, alpha)
% This function computes the Fourier Transform using the quadrature method.
%% Inputs:
% kappa:    curtosis
% eta:      skewness
% ttm:      time to maturity
% sigma:    volatility
% x:        Vector of target log-moneyness values to interpolate
% alpha:    coefficient in (0,1]

%% Output:
% I:        value of the Fourier Transform using quadrature method

z_up_limit = 20; % To handle it in order to obtain the best result possible
N_z = 100;

z = linspace(0, z_up_limit, N_z);

% Calculate the integrand function in this points:
f_z = integrand(z, kappa, eta, ttm, sigma, alpha);

% x is a row in the main, so we transpose in order to obtain a matrix 
% doing x'*z.
% We take only the real part because the Lewis integral is on the real axis
total_integranda = real(exp((-1).*(1i).* (x'*z)).* f_z);

% We use trapz in order to not use a for cycle to compute the integrand for
% each value that we need
I = trapz(z, total_integranda, 2);

% Final thing to do the product of, which is out of the Lewis formula
I = (1/pi) .* exp(-x./2) .* I'; 

