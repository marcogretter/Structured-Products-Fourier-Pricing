function I = FFT_point_3(N, p_plus, p_minus, x, mu, dz)
% This function computes the Fourier Transform using the FFT method.
% The integrand f_z is calculated in the 'integrand.m' function

%% Inputs:
% N :       number of steps
% p_plus:   parameter
% p_minus:  parameter
% x:        Vector of target log-moneyness values to interpolate
% mu:       drift compensator
% dz:       

%% Output:
% I:        value of the Fourier Transform using FFT method

% From the hypothesis of FTT seen in class:
dx = (2*pi)/(N*dz);
z1 = -dz*(N-1)/2;
z = z1 + (0:(N-1))*dz;

% Partial part of the integrand function:
f_z = integrand_point_3(z, mu, p_plus, p_minus);

% Grid limit:
b = N * dx / 2;

% Final grid:
x_for_FFT = -b + (0:N-1) * dx;

% Starting to define the complete integrand in order to do the FFT
% Nota: e^(-ixz) è già nell'integranda della Trasformata di Fourier

% Add shift exp(1i * b * z) in order to align the grid to -b
integranda = f_z .* exp(1i .* b .* z) .* dz;
% Trapezium rule
integranda(1) = integranda(1)/2;
integranda(end) = integranda(end)/2;
transform = fft(integranda);

shift_post_fft = exp(-1i .* z1 .* (x_for_FFT - x_for_FFT(1)));

transform = real(shift_post_fft .* transform);

% I also do the product with the terms out of the integral in Lewis
% formula:

transform = (1/(2*pi)) .* transform;

% Interpolation
I = interp1(x_for_FFT, transform, x, "spline");
I =  exp(-x./ 2) .* I;
