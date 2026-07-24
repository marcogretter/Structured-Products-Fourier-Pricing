function I = residuals_point3(mu, p_plus, p_minus,x)
% This function computes the Lewis integral using the Residues 
% technique
    
% Constants and y variable
A = p_plus * p_minus * exp(0.5 * mu);
y = x + mu;
    
% Poles of the integrand function 
v1 = 0.5;
v2 = -0.5;
v3 = -0.5 + p_plus;
v4 = -(p_minus + 0.5);

% Product of the distance between the poles
P1 = (v1 - v2) * (v1 - v3) * (v1 - v4);
P2 = (v2 - v1) * (v2 - v3) * (v2 - v4);
P3 = (v3 - v1) * (v3 - v2) * (v3 - v4);
P4 = (v4 - v1) * (v4 - v2) * (v4 - v3);

% intialization
I_raw = zeros(size(x));
    
% Case y < 0 
idx_neg = (y < 0);
I_raw(idx_neg) = -A .* ( exp(v1 .* y(idx_neg)) ./ P1 + exp(v3 .* y(idx_neg)) ./ P3 );
    
% Case 2: y >= 0 
idx_pos = (y >= 0);
I_raw(idx_pos) = A .* ( exp(v2 .* y(idx_pos)) ./ P2 + exp(v4 .* y(idx_pos)) ./ P4 );

I = exp(-x ./ 2) .* I_raw;
end

