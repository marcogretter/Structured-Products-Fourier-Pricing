% Assignment 4
% Group 8, AY2025-2026
clear all; close all; clc;
load("eurostoxx_Poli.mat");
% Set the seed for reproducibility and number of simulations (see points 1,3 and 4)
rng(1); n_simu=1000000;
%% For Mac user:
[datesSet, ratesSet] = readExcelData('MktData_CurveBootstrap.xlsx');
%% For Windows user:
%[datesSet, ratesSet] = readExcelDataWindows('MktData_CurveBootstrap.xlsx', formatData)
[dates, discounts, zeroRates] = bootstrap(datesSet, ratesSet);

%% 1. Certificate pricing
settlement = datesSet.settlement;
% Initialize parameters
[T_anni, B_T, r, payment_discounts, delta_t, P]= initialize_parameters_1(settlement, dates, discounts);

% CF of A is totallyrelated to the one done in lecture on swaps done in 
% credit (it is exactly the same formula)
PV_Floating = 1 - B_T;
s_spol = 0.013;
PV_Spread = s_spol * sum(delta_t .* payment_discounts);

% To the "normal" CF in struct products swaps you have to add also the
% protection part (which is paid at maturity)
PV_Protection = (1-P) * B_T;

% We discount the payoff of the B counterparty's coupon given by the 
% MonteCarlo simulation
payoff = MC_simulation_point_1(n_simu, r, P, T_anni);
PV_Coupon = mean(payoff) * B_T;

% Final result:
% PV_Floating + PV_Spread + PV_Protection = X + PV_Coupon
X_dec = PV_Floating + PV_Spread + PV_Protection - PV_Coupon;
X = 100 * X_dec;   % X% upfront (so we convert it in percentage)
fprintf('Theoretical upfront X = %.3f%% of the nominal\n', X);

%% 2. Digital Option pricing
% Initialize parameters and some basic computations
[strikes, surface, S0, T, q, zero_rates, r, Notional, K, df, Cash,F, B_T] = initialize_parameters_2(settlement, cSelect, dates, discounts);

% ATM vol (interpolate at K = F)
vol_atm   = interp1(strikes, surface, F, 'linear', 'extrap');

%  Black model - Digital Call (flat ATM vol)
sigma_atm   = interp1(strikes, surface, K, 'linear', 'extrap');
d1_black    = (log(F/K) + 0.5*sigma_atm^2*T) / (sigma_atm*sqrt(T));
d2_black    = d1_black - sigma_atm*sqrt(T);
price_black = Cash * df * normcdf(d2_black);

%  Smile correction - Formula analitica corretta
dK         = 1; K_up = K + dK; K_down = K - dK;
sigma_up   = interp1(strikes, surface, K_up,   'linear', 'extrap');
sigma_down = interp1(strikes, surface, K_down, 'linear', 'extrap');

% Smile slope dsigma/dK
dvol_dK    = (sigma_up - sigma_down) / (2*dK);
% d1 e d2 alla strike K con vol ATM
sigma_K    = interp1(strikes, surface, K, 'linear', 'extrap');
d1_K       = (log(F/K) + 0.5*sigma_K^2*T) / (sigma_K*sqrt(T));
d2_K       = d1_K - sigma_K*sqrt(T);
% Vega call
vega_call = df * normpdf(d1_K) * sqrt(T) * F;
correction = Cash * vega_call * dvol_dK;
price_smile_analytic = price_black - correction;
%  Call spread (verifica numerica)
call_up   = black_call(F, K_up,   sigma_up,   r, T);
call_down = black_call(F, K_down, sigma_down, r, T);
price_callspread = Cash * (call_down - call_up) / (2*dK);

% Summary
summary_results_2(S0,F,K,sigma_atm,d1_black,d2_black,dvol_dK,price_black,price_smile_analytic,price_callspread,correction,Cash,d1_K,d2_K,vega_call)
% Plot
plot_results_2(strikes, surface, F)

%% 3. Pricing with characteristic function
% Initialize parameters, including mu for which we applied the MG condition
[p_plus, p_minus, x, mu, F0, B_ttm, dz, N]= initialize_parameters_3(settlement,cSelect, dates, discounts);
% a) Price with quadrature:
I_quadrature_point_3 = quadrature_point_3(mu, p_plus, p_minus, x);
price_quadrature_point_3 = (B_ttm*F0).*(1 - I_quadrature_point_3);

% b) Price with the residuals technique
I_residuals_point_3 = residuals_point3(mu, p_plus, p_minus,x);
price_residuals_point_3 =(B_ttm*F0).*(1 - I_residuals_point_3);

% c) Price with MC
% Strikes:
K= F0.*exp(-x); % (slide 10)
f_t = logreturns_MC_point_3(n_simu,mu, p_plus, p_minus);
F_t = F0.*exp(f_t);
payoff3 = max(F_t - K, 0);
price_MC_point_3 = B_ttm .* mean(payoff3);

% d) Price with FFT
I_FFT_point_3 = FFT_point_3(N, p_plus, p_minus, x, mu, dz);
price_FFT_point_3 = (B_ttm*F0).*(1 - I_FFT_point_3);

%% 4. Pricing:
% Initialize parameters:
[alpha,sigma,k,eta,dx,x,ttm,F0,B_ttm,N]= initialize_parameters_4(settlement,cSelect, dates, discounts);

% a) FFT:
I_fft = FFT(dx, N, k, eta, ttm, sigma, x, alpha);
price_FFT = (B_ttm*F0).*(1 - I_fft);

% b) Quadrature
I_quadrature = quadrature(k, eta, ttm, sigma, x, alpha);
price_quadrature = (B_ttm*F0).*(1 - I_quadrature);

% c) Monte-Carlo
% Strikes:
K= F0.*exp(-x); % (slide 10)
f_t = logreturns_MC(k, eta, ttm, sigma, n_simu);
F_t = F0.*exp(f_t);
payoff = max(F_t - K, 0);
price_MC = B_ttm .* mean(payoff);
check_moments(f_t, eta, sigma, ttm, k);

% d) optional, alpha = 1/3:
% FFT:
I_fft_alpha_un_terzo = FFT(dx, N, k, eta, ttm, sigma, x, 1/3);
price_FFT_alpha_un_terzo = (B_ttm*F0).*(1 - I_fft_alpha_un_terzo);
% Quadrature:
I_quadrature_alpha_un_terzo = quadrature(k, eta, ttm, sigma, x, 1/3);
price_quadrature_alpha_un_terzo = (B_ttm*F0).*(1 - I_quadrature_alpha_un_terzo);

% Plotting the results:
plot_results_4(x, price_FFT, price_quadrature, price_MC, price_FFT_alpha_un_terzo, price_quadrature_alpha_un_terzo);

%% 5. Volatility surface calibration
%data
[strikes, surface, S0, T, q, zero_rates, r, Notional, K, df, Cash,F, B_T] = initialize_parameters_2(settlement, cSelect, dates, discounts);
alpha = 2/3;
x_mkt = log(F./strikes(:));  

%calibration
I = @(kappa,eta,sigma) FFT(dx, N, kappa, eta, T, sigma, x_mkt, alpha);
Price_Lewis = @(kappa,eta,sigma) B_T*F*(1-I(kappa,eta, sigma)); % price with Lewis formula
C = black_call(F, strikes(:), surface(:), r, T); % price call with black 
p0 = [0.5, 1, 0.5];  % starting values
d =  @(p) sum( (Price_Lewis(p(1),p(2),p(3)) - C).^2 );
lb  = [0.1, -50,  0.1]; % lower bound
ub  = [1.0, 50,  1.0];  % upper bound
nonlcon = @(p)  deal(-p(2) - (1 - alpha) ./ (p(1) .* p(3).^2), []) ;
x_cal = fmincon(d,p0,[],[],[],[],lb,ub,nonlcon); % minimization 
% plot
plot_results_5(x_cal, x_mkt, strikes, surface, F, B_T, T, r, dx, N, alpha)
