function [strikes, surface, S0, T, q, zero_rates, r, Notional, K, df, Cash,F, B_T] = initialize_parameters_2(settlement, cSelect, dates, discounts)
% This function has the only goal to reduce the main's lines and to make
% the main more readable and skinnier

% Strikes
strikes = cSelect.strikes; % 31 strikes from 3050 to 3550

% Implied volatility surface (from cSelect.surface)
surface = cSelect.surface;

% Market parameters
S0 = cSelect.reference;    % ATM Spot (reference)
T = cSelect.maturity;      % Maturity 1y (Act/365)
q = cSelect.dividends;     % Dividend yield

% Discount at maturity (ie, B(0,1))
maturityDate = dateAddMonth(settlement, 1*12);
B_T = get_discount_factor_by_zero_rates_linear_interp(settlement, maturityDate, dates, discounts);
discount_factors = get_discount_factor_by_zero_rates_linear_interp(settlement, maturityDate, dates, discounts);
zero_rates = from_discount_factors_to_zero_rates(dates, discount_factors);
r = -log(B_T);

% Forward price: F = S0 * exp((r - q) * T)
F = S0 * exp((r - q) * T);

% Notional and payoff
Notional = 10e6;       % 10 Mln EUR
payoff = 0.05;       % 5% of Notional
Cash = Notional * payoff;   % = 500,000 EUR

% Strike for the digital: we use ATM forward as the digital barrier
K = F;          % ATM digital

% Discount factor
df = exp(-r * T);
