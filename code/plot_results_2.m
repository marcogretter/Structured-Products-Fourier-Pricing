function plot_results_2(strikes, surface, F)


figure('Color','w');
plot(strikes, surface*100, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
xline(F, 'r--', 'LineWidth', 1.5, 'Label', sprintf('F = %.0f', F));
xlabel('Strike');
ylabel('Implied Volatility (%)');
title('Eurostoxx50 Vol Smile - 15 Feb 2008 (1Y)');
grid on;
