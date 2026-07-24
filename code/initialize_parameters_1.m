function [T_anni, B_T, r, payment_discounts, delta_t, P]= initialize_parameters_1(settlement, dates, discounts)
% This function has the only goal to reduce the main's lines and to make
% the main more readable and skinnier

T_anni = 5;
P = 0.95;

% Discount at maturity (ie, B(0,5))
maturityDate = dateAddMonth(settlement, T_anni*12);
B_T = get_discount_factor_by_zero_rates_linear_interp(settlement, maturityDate, dates, discounts);

% rate for the MC simulation
r = -log(B_T) / T_anni; 
% 20 trimestri in 5 anni
months_to_add = (1:20)' * 3;

% Computation of the payment_dates
payment_dates = arrayfun(@(m) dateAddMonth(settlement, m), months_to_add);

% Discount factors
payment_discounts = arrayfun(@(d) get_discount_factor_by_zero_rates_linear_interp(settlement, d, dates, discounts), payment_dates);

% delta_t (fraction of years)
% Il vettore delle date precedenti è semplicemente il settlement seguito da tutte le payment_dates tranne l'ultima
prev_dates = [settlement; payment_dates(1:end-1)];

% Act/360 convention
delta_t = yearfrac(prev_dates, payment_dates, 2);