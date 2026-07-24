function [alpha,sigma,k,eta,dx,x,ttm,F0,B_ttm,N]= initialize_parameters_4(settlement,cSelect, dates, discounts)
% This function has the only goal to reduce the main's lines and to make
% the main more readable and skinnier

alpha = 1/2;
sigma = 0.2;
k = 1; % volatility of the volatility
eta = 3; % skewness
M = 12; N = 2^M;
% moneyness x between -25% and 25% in a grid with 1% steps
dx= 0.01; % 1% steps
x = -0.25 : dx : 0.25;
ttm=1;
F0 = cSelect.reference;
% discount factor
interp_date = dateAddMonth(settlement, 12*ttm);
B_ttm = get_discount_factor_by_zero_rates_linear_interp(settlement, interp_date, dates, discounts);