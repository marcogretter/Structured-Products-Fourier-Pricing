function f_z = integrand_point_3(z, mu, p_plus, p_minus)
% This function has the goal to compute the integrand function of
% the integral of Lewis to price an option:

%% Inputs:
% z:        integration variable in the complex plane (Fourier space)
% mu:       drift compensator
% p_plus:   parameter
% p_minus:   parameter

%% Outputs:
% f_z: value of the integrand in the Fourier transform (ONLY THE f_z, not 
%      the exp(...), since it is already included in the Fourier Transform'
%      definition)

% Definition of the characteristic function
phi = @(u) exp((1i * mu).*u) .* (1 ./ ((1 - u.*(1i/p_plus)) .* (1 + u.*(1i/p_minus))));

% definition of the argument of the characteristic function:
u = -(z + ((1i)/2));

% Calculation of the charact function of the argument of the Lewis
% formula's integral
phi_z = phi(u);

% Argument of the Lewis Formula integral (w/o the terms of x)
f_z = phi_z ./ ((z.^2) + 1/4);
