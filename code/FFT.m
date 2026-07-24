function I = FFT(dx, N, kappa, eta, ttm, sigma, x, alpha)
% This function computes the Fourier Transform using the FFT method.
% The integrand f_z is calculated in the 'integrand.m' function

%% Inputs:
% dx:       stepsize of log-moneyness grid
% N :       number of steps
% kappa:    curtosis
% eta:      skewness
% ttm:      time to maturity
% sigma:    volatility
% x:        Vector of target log-moneyness values to interpolate
% alpha:    coefficient in (0,1]

%% Output:
% I:        value of the Fourier Transform using FFT method

% From the hypothesis of FTT seen in class:
dz = (2*pi)/(N*dx);
z1 = -dz*(N-1)/2;
z = z1 + (0:(N-1))*dz;

% Partial part of the integrand function:
f_z = integrand(z, kappa, eta, ttm, sigma, alpha);

% Grid limit (confronta con altri):
b = N * dx / 2;

% Final grid:
x_for_FFT = -b + (0:N-1) * dx;

% Starting to define the complete integrand in order to do the FFT
% Nota per non fare le cose due volte: e^(-ixz) è già nell'integranda 
% della Trasformata di Fourier

% Add shift exp(1i * b * z) in order to align the grid to -b
integranda = f_z .* exp(1i .* b .* z) .* dz;
% Trapezium rule
integranda(1) = integranda(1)/2;
integranda(end) = integranda(end)/2;

% Calculate the transform
transform = fft(integranda);

shift_post_fft = exp(-1i .* z1 .* (x_for_FFT - x_for_FFT(1)));

% Only the real part
transform = real(shift_post_fft .* transform);

% I also do the product with the terms out of the integral in Lewis
% formula:
transform = (1/(2*pi)) .* transform;

% Interpolate
I = interp1(x_for_FFT, transform, x, "spline");
I =  exp(-x./ 2) .* I;
