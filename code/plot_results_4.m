function plot_results_4(x, price_FFT_NIG, price_quad_NIG, price_MC_NIG, price_FFT_alpha_un_terzo, price_quad_alpha_un_terzo)
% This function plots the call option prices for both the NIG and alpha=1/3 case models.
% It generates a figure with two subplots to compare FFT, Quadrature, and MC.
figure('Name','FTT Vs Quadrature')
plot(x, price_FFT_NIG, 'r-', 'LineWidth', 1.5, 'DisplayName', 'FFT');
hold on;
plot(x, price_quad_NIG, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Quadrature');
grid on;
xlabel('Log-Moneyness (x)');
ylabel('Call Option Price');
title('\alpha = 1/2');
legend('Location', 'best');


figure('Name', 'Pricing Options: NIG vs VG', 'NumberTitle', 'off');

% Subplot 1: NIG
subplot(1, 2, 1);
plot(x, price_FFT_NIG, 'r-', 'LineWidth', 1.5, 'DisplayName', 'FFT');
hold on;
plot(x, price_quad_NIG, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Quadrature');
plot(x, price_MC_NIG, 'b.', 'MarkerSize', 10, 'DisplayName', 'Monte Carlo');
grid on;
xlabel('Log-Moneyness (x)');
ylabel('Call Option Price');
title('\alpha = 1/2');
legend('Location', 'best');

% Subplot 2: alpha = 1/3
subplot(1, 2, 2);
plot(x, price_FFT_alpha_un_terzo, 'r-', 'LineWidth', 1.5, 'DisplayName', 'FFT');
hold on;
plot(x, price_quad_alpha_un_terzo, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Quadrature');
grid on;
xlabel('Log-Moneyness (x)');
ylabel('Call Option Price');
title('\alpha = 1/3');
legend('Location', 'best');

figure('Name','\alpha = 1/2 Vs alpha = 1/3')
plot(x, price_FFT_NIG, 'r-', 'LineWidth', 1.5, 'DisplayName', 'FFT \alpha = 1/2');
hold on;
plot(x, price_quad_NIG, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Quadrature \alpha = 1/2');
plot(x, price_FFT_alpha_un_terzo, 'b-', 'LineWidth', 1.5, 'DisplayName', 'FFT \alpha = 1/3');
plot(x, price_quad_alpha_un_terzo, 'y--', 'LineWidth', 1.5, 'DisplayName', 'Quadrature \alpha = 1/3');
grid on;
xlabel('Log-Moneyness (x)');
ylabel('Call Option Price');
title('Comparison between \alpha = 1/2 and \alpha = 1/3');
legend('Location', 'best');


end