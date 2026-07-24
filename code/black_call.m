function C = black_call(F, K, sigma, r, T)
F     = F(:);
K     = K(:);
sigma = sigma(:);
r     = r(:);
T     = T(:);

d1 = (log(F./K) + 0.5.*sigma.^2.*T) ./ (sigma.*sqrt(T));
d2 = d1 - sigma.*sqrt(T);

C = exp(-r.*T) .* (F.*normcdf(d1) - K.*normcdf(d2));
end