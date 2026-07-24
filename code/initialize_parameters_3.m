function [p_plus, p_minus, x, mu, F0, B_ttm, dz, N]= initialize_parameters_3(settlement,cSelect, dates, discounts)
% This function has the only goal to reduce the main's lines and to make
% the main more readable and skinnier

dz = 0.1;

p_plus = 1.5;
p_minus = 0.9;
M = 10; % play with it until you find the best one for your purposes 
        % (ideally M in [10,15])
N = 2^M;

x = [-0.05223, 0, 0.15];
F0 = cSelect.reference;
ttm = 1;
% discount factor
interp_date = dateAddMonth(settlement, 12*ttm);
B_ttm = get_discount_factor_by_zero_rates_linear_interp(settlement, interp_date, dates, discounts);


% From the martingale condition we can compute mu by hand, stating that:
% 1 = E[e^f]:
mu = log((1 - (1/p_plus)) * (1 + (1/p_minus)));