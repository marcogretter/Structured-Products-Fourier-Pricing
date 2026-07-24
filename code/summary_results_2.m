function summary_results_2(S0,F,K,sigma_atm,d1_black,d2_black,dvol_dK,price_black,price_smile_analytic,price_callspread,correction,Cash,d1_K,d2_K,vega_call)
fprintf('\n BLACK MODEL\n');
fprintf('sigma ATM = %.4f\n', sigma_atm);
fprintf('d1        = %.6f\n', d1_black);
fprintf('d2        = %.6f\n', d2_black);
fprintf('N(d2)     = %.6f\n', normcdf(d2_black));
fprintf('Price     = EUR %.2f\n', price_black);

fprintf('\n SMILE CORRECTION (Analitica Corretta)\n');
fprintf('d1            = %.6f\n', d1_K);
fprintf('d2            = %.6f\n', d2_K);
fprintf('n(d2)         = %.6f\n', normpdf(d2_K));
fprintf('dvol/dK       = %.6f\n', dvol_dK);
fprintf('Vega call  = %.6f\n', vega_call);

fprintf('\n DIGITAL OPTION SUMMARY\n');
fprintf('Spot            : %.2f\n', S0);
fprintf('Forward         : %.2f\n', F);
fprintf('Strike (ATM)    : %.2f\n', K);
fprintf('sigma ATM       : %.4f\n', sigma_atm);
fprintf('dvol/dK         : %.6f\n\n', dvol_dK);
fprintf('Price Black     : EUR %10.2f\n', price_black);
fprintf('Price Smile     : EUR %10.2f\n', price_smile_analytic);
fprintf('Price CallSpread: EUR %10.2f\n', price_callspread);
fprintf('Correction      : EUR %10.2f\n', correction);
fprintf('Diff (%% payoff) : %.4f%%\n', 100*correction/Cash);