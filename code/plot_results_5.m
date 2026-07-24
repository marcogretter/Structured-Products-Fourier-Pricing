function plot_results_5(x_cal, x_mkt, strikes, surface, F, B_T, T, r, dx, N, alpha)
% Plots the market vs model implied volatility surface after calibration.

% Inputs:
%   x_cal   : calibrated parameters [kappa, eta, sigma]
%   strikes : vector of market strikes
%   surface : vector of market implied volatilities
%   F       : forward price (from Exercise 2)
%   B_T     : discount factor (from Exercise 2)
%   T       : time to maturity (from Exercise 2)
%   r       : risk-free rate (from Exercise 2)
%   dx      : FFT log-moneyness step
%   N       : FFT number of points
%   alpha   : model parameter (2/3)

kappa = x_cal(1);
eta   = x_cal(2);
sigma = x_cal(3);

strikes = strikes(:);
surface = surface(:);

% Model prices at calibrated parameters
I_cal = FFT(dx, N, kappa, eta, T, sigma, x_mkt, alpha);
C_model = B_T*F*(1-I_cal);

% Invert model prices to implied volatility (Black model)

model = zeros(size(strikes));
for i = 1:length(strikes)
    fun = @(sig) black_call(F, strikes(i), sig, r, T) - C_model(i);
    try
        model(i) = fzero(fun, [1e-5, 5]);
    catch
        model(i) = NaN;
    end
end

% Plot
figure('Name', 'Exercise 5 - Volatility Surface Calibration', 'NumberTitle', 'off', 'Color', 'w');
plot(x_mkt, surface  * 100, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 5, ...
     'DisplayName', 'Market ');
hold on;
plot(x_mkt, model * 100, 'r--*', 'LineWidth', 1.5, 'MarkerSize', 7, ...
     'DisplayName', sprintf('Model  (\\kappa=%.3f, \\eta=%.3f, \\sigma=%.3f)', ...
                            kappa, eta, sigma));
xlabel('log-moneyness');
ylabel('Implied Volatility (%)');
title('Volatility Surface Calibration  (\alpha = 2/3)');
legend('Location', 'best');
grid on;

end
