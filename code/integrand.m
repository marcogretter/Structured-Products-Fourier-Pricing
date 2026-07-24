function f_z = integrand(z, kappa, eta, ttm, sigma, alpha)
% This function has the goal to compute the integrand function of
% the integral of Lewis to price an option:

%% Inputs:
% z:        integration variable in the complex plane (Fourier space)
% kappa:    curtosis
% eta:      skewness
% ttm:      time to maturity
% sigma:    volatility
% alpha:    coefficient in (0,1]

%% Outputs:
% f_z: value of the integrand in the Fourier transform (ONLY THE f_z, not 
%      the exp(...), since it is already included in the Fourier Transform'
%      definition)

% Analytic solution for Laplace exponent seen in class (NIG case):
% In the beginning I computed the ln of the Laplace transform because I was
% implementing letter by letter the formulas seen in class. I mean, it's
% still correct, but maybe the best was to compute the Laplace transform
% and not the ln of the Laplace transform. 
% The important thing is that you remember that it is the ln, also I wrote
% lne_L and not L

% We define the laplace exponent in general, so if I want to try for
% different values of alpha I can do it
lne_L = @(omega) ((ttm/kappa)*((1-alpha)/alpha)).*(1 - (1 + (((kappa*(sigma^2)).*omega)./(1-alpha))).^alpha);

% From the martingale condition (WP) we know the value of mu:
mu = - lne_L(eta);

% Definition of the characteristic function in the NMVM case (saw in
% class):

% definition of the argument of the characteristic function:
u = -(z + ((1i)/2));

% Characteristic function in the NMVM in general (with the MG condition 
% already applied):
phi = @(csi) exp(1i .* csi .* mu) .* exp(lne_L((1/2) .* ((csi.^2) + (1i).*(1 + 2.*eta).*csi)));

% Calculation of the charact function of the argument of the Lewis
% formula's integral
phi_z = phi(u);

% Argument of the Lewis Formula integral (w/o the terms of x)
f_z = phi_z ./ ((z.^2) + 1/4);